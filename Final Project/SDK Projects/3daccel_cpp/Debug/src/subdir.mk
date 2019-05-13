################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

CC_SRCS += \
../src/main.cc 

CPP_SRCS += \
../src/chu_init.cpp \
../src/gpio_cores.cpp \
../src/spi_core.cpp \
../src/sseg_core.cpp \
../src/timer_core.cpp \
../src/uart_core.cpp 

CC_DEPS += \
./src/main.d 

OBJS += \
./src/chu_init.o \
./src/gpio_cores.o \
./src/main.o \
./src/spi_core.o \
./src/sseg_core.o \
./src/timer_core.o \
./src/uart_core.o 

CPP_DEPS += \
./src/chu_init.d \
./src/gpio_cores.d \
./src/spi_core.d \
./src/sseg_core.d \
./src/timer_core.d \
./src/uart_core.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: MicroBlaze g++ compiler'
	mb-g++ -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -I../../3d_proj_bsp_0/microblaze_I/include -mno-xl-reorder -mlittle-endian -mcpu=v10.0 -mxl-soft-mul -Wl,--no-relax -ffunction-sections -fdata-sections -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/%.o: ../src/%.cc
	@echo 'Building file: $<'
	@echo 'Invoking: MicroBlaze g++ compiler'
	mb-g++ -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -I../../3d_proj_bsp_0/microblaze_I/include -mno-xl-reorder -mlittle-endian -mcpu=v10.0 -mxl-soft-mul -Wl,--no-relax -ffunction-sections -fdata-sections -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


