/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2025 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "i2c.h"
#include "rtc.h"
#include "usart.h"
#include "gpio.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "mpu6050.h"
#include <stdio.h>
#include <string.h>
#include <math.h>
/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/

/* USER CODE BEGIN PV */
MPU6050_t MPU6050;
uint8_t msgBuffer[128];
int16_t halDelayDuration = 100;

double accelX = 0;
double accelY = 0;
double accelZ = 0;
double gyroX = 0;
double gyroY = 0;
double gyroZ = 0;

double baseangleX = 0;
double baseangleY = 0;
double gyroX_1 = 0;
double gyroY_1 = 0;
double gyroZ_1 = 0;

double baseAccelX = 0;
double baseAccelY = 0;
double baseAccelZ = 0;
double baseGyroX = 0;
double baseGyroY = 0;
double baseGyroZ = 0;

uint32_t prevTime = 0;
uint32_t currentTime = 0;
float dt = 0.0f;
float alpha = 0.02f;

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */

/* USER CODE END 0 */

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{

  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration--------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_RTC_Init();
  MX_I2C1_Init();
  MX_USART2_UART_Init();
  /* USER CODE BEGIN 2 */
  while (MPU6050_Init(&hi2c1) == 1);
  HAL_UART_Transmit(&huart2, (uint8_t *)"MPU6050 initialized\r\n", sizeof("MPU6050 initialized\r\n"), 1000);
  CallibAccelGyro();
  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
    MPU6050_Read_All(&hi2c1, &MPU6050);
    accelX = MPU6050.Ax;
    accelY = MPU6050.Ay;
    accelZ = MPU6050.Az;
    gyroX = MPU6050.Gx;
    gyroY = MPU6050.Gy;
    gyroZ = MPU6050.Gz;

    currentTime = HAL_GetTick();  // 현재 시간(ms)
    dt = (currentTime - prevTime) / 1000.0f;  // 초 단위로 변환
    prevTime = currentTime;


    baseangleY = atan2(-baseAccelX ,sqrt(baseAccelY*baseAccelY + baseAccelZ*baseAccelZ)) * 180.0 / M_PI;
    baseangleX = atan2(baseAccelY, baseAccelZ) * 180.0 / M_PI ;

    float angleX = atan2(accelY, accelZ) * 180.0 / M_PI;     // roll
    float angleY = atan2(-accelX ,sqrt(accelY*accelY + accelZ*accelZ)) * 180.0 / M_PI;  // pitch


    int X = round(angleX-baseangleX) ;
    int Y = round(angleY-baseangleY) ;
  
    gyroX_1 += (gyroX-baseGyroX)*dt ;
    gyroY_1 += (gyroY-baseGyroY)*dt ;
    gyroZ_1 += (gyroZ-baseGyroZ)*dt ;

    int X_g = round(gyroX_1);
    int Y_g = round(gyroY_1);
    int Z_g = round(gyroZ_1);

    int roll = alpha * (gyroX_1 + gyroX*dt) + (1-alpha)*angleX ;
    int pitch = alpha * (gyroY_1 + gyroY*dt) + (1-alpha)*angleY ;


    sprintf((char *)msgBuffer, "%d,%d,%d,%d,%d,%d,%d\r\n",X, Y, X_g, Y_g, Z_g, roll, pitch);
    HAL_UART_Transmit(&huart2, (uint8_t *)msgBuffer, strlen((char *)msgBuffer), 1000);
    

    HAL_Delay(halDelayDuration);
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
  }

  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

  /** Configure the main internal regulator output voltage
  */
  __HAL_RCC_PWR_CLK_ENABLE();
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

  /** Initializes the RCC Oscillators according to the specified parameters
  * in the RCC_OscInitTypeDef structure.
  */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE|RCC_OSCILLATORTYPE_LSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_BYPASS;
  RCC_OscInitStruct.LSEState = RCC_LSE_ON;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
  RCC_OscInitStruct.PLL.PLLM = 4;
  RCC_OscInitStruct.PLL.PLLN = 100;
  RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
  RCC_OscInitStruct.PLL.PLLQ = 4;
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }

  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_3) != HAL_OK)
  {
    Error_Handler();
  }
}

/* USER CODE BEGIN 4 */
void CallibAccelGyro()
{
  double sumAccelX = 0;
  double sumAccelY = 0;
  double sumAccelZ = 0;
  double sumGyroX = 0;
  double sumGyroY = 0;
  double sumGyroZ = 0;

  for (int i = 0; i < 10; i++)
  {
    MPU6050_Read_All(&hi2c1, &MPU6050);
    sumAccelX += MPU6050.Ax;
    sumAccelY += MPU6050.Ay;
    sumAccelZ += MPU6050.Az;
    sumGyroX += MPU6050.Gx;
    sumGyroY += MPU6050.Gy;
    sumGyroZ += MPU6050.Gz;
    HAL_Delay(halDelayDuration);
  }

  baseAccelX = sumAccelX / 10;
  baseAccelY = sumAccelY / 10;
  baseAccelZ = sumAccelZ / 10;
  baseGyroX = sumGyroX / 10;
  baseGyroY = sumGyroY / 10;
  baseGyroZ = sumGyroZ / 10;
}
/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */
