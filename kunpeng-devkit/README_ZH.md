# 前言

## 概述
本文档介绍了鲲鹏DevKit命令行工具的使用方法，对鲲鹏DevKit命令行工具操作及其各项子功能做了详细介绍。

## 读者对象
本文档主要适用于以下人员：
- 鲲鹏平台开发者
- 鲲鹏平台的软件用户
- ISV开发者

## 修改记录
<table>
  <tr>
    <th>文档版本</th>
    <th>发布日期</th>
    <th>修改说明</th>
  </tr>
  <tr>
    <td>07</td>
    <td>2025-09-30</td>
    <td>knet分析工具更名为链路时延检测工具，新增以attach方式采集数据的能力。</td>
  </tr>
  <tr>
    <td>06</td>
    <td>2025-06-30</td>
    <td>HPC调试器新增attach功能。</td>
  </tr>
  <tr>
    <td>05</td>
    <td>2025-03-30</td>
    <td>命令行新增HPC调试器debugger、JVM性能波动诊断工具diag。亲和分析新增knet分析工具，dr-check更新功能描述。</td>
  </tr>
  <tr>
    <td>04</td>
    <td>2025-03-30</td>
    <td>系统迁移新增扫描Maven工程在鲲鹏服务器兼容情况和项目依赖修改建议的功能。</td>
  </tr>
  <tr>
    <td>03</td>
    <td>2025-03-30</td>
    <td>命令行报告文件格式中英文归一。</td>
  </tr>
  <tr>
    <td>02</td>
    <td>2024-06-30</td>
    <td>亲和分析子任务名称变更，并新增生成BC文件、缓存行对齐检查和矩阵化检查功能。</td>
  </tr>
  <tr>
    <td>01</td>
    <td>2024-03-30</td>
    <td>第一次正式发布。</td>
  </tr>
</table>

# 1 介绍
鲲鹏DevKit提供终端客户端工具以在任意服务器的CLI模式下完成分析任务及工具管理。

# 2 命令入口简介

## 命令格式

```shell
devkit [-h | --help] [-v | --version] COMMAND [ARGS]
```

## 简介
若已安装工具或使用压缩包解压，可通过-h参数查看工具支持项，-v参数查看当前版本。

```text
[说明]
示例均为安装RPM包方式使用, 如使用tar包方式解包使用，需要绝对路径执行，或cd到解包路径后./devkit执行。
```

```shell
devkit -h
```
x86-64架构下回显：
```shell
Usage: devkit [-h | --help] [-v | --version] COMMAND [ARGS]

 The most commonly used devkit sub commands are:
   help      Get help information
   version   Get version information
   porting   Run a command for porting
   sys-mig   Run a command for system migration
   advisor   Run a command for advisor
   report    Read specific_name.tar and display the result
 See 'devkit COMMAND --help' for more information on a specific command.
```
porting为应用迁移，sys-mig为系统迁移，advisor为亲和分析，report可查看任务输出报告形式为TAR包的结果。详情请参见本README中3 应用迁移、4 系统迁移、5 亲和分析三大节。

aarch64架构下回显：
```shell
Usage: devkit [-h | --help] [-v | --version] COMMAND [ARGS]

 The most commonly used devkit sub commands are:
   help        Get help information
   version     Get version information
   porting     Run a command for porting
   sys-mig     Run a command for sys-mig
   advisor     Run a command for advisor
   tuner       Run a command for system performance analysis
   doctor      Run a command for system diagnosis analysis
   java-perf   Run a command for java analysis
   py-perf     Run a command for python analysis
   kat         Run a command for kunpeng automatic tuning analysis
   debugger    Run a command for kunpeng debugger
   report      Read specific_name.tar and display the result
   diag        Run a command for JVM analysis
 See 'devkit COMMAND --help' for more information on a specific command.
```
porting为应用迁移，sys-mig为系统迁移，advisor为亲和分析，tuner为系统性能分析，doctor为系统诊断分析，java-perf为java性能分析，py-perf为Python性能分析，kat为鲲鹏自动调优，debugger为HPC调试器，report可查看任务输出报告形式为TAR包的结果，diag为JVM性能波动诊断工具。详情请参考下文。

# 3 应用迁移

## 3.1 命令行参数说明
鲲鹏DevKit提供终端客户端工具以在任意服务器的CLI模式下完成应用迁移分析任务。

### 命令功能
查看所有命令参数说明。

### 命令格式
查看所有命令参数说明。
```shell
devkit porting -h
```

### 使用实例
运行以下命令，查看所有命令参数说明。
```shell
devkit porting -h
```
返回信息如下：
```shell
Usage: devkit porting [-h|--help] TASK [ARGS]

  The most commonly used devkit advisor sub tasks are:
    src-mig                  Run the source migration task.
    pkg-mig                  Run the package migration task.
See 'devkit porting TASK -h/--help' for more information on a specific task.
```

## 3.2 软件迁移评估

### 3.2.1 命令参数说明
软件迁移评估帮助用户分析用户x86环境上软件包安装路径中的SO库文件，并检查这些文件与鲲鹏平台的兼容性。

#### 命令功能
查看软件迁移评估特性所有命令参数。

#### 命令格式
```shell
devkit porting pkg-mig -h
```

#### 使用实例
执行以下命令，查看所有命令参数说明。
```shell
devkit porting pkg-mig -h
```
返回信息如下：
```shell
    OVERVIEW
        Run this command to scan and analyze software packages (non-source code packages) and installed software, and provides migration evaluation reports.

    USAGE
        devkit porting pkg-mig -i,--input path-to-package [-o,--output path-to-output] [-r,--report-type {all/json/html/csv}] [-l,--log-level {0/1/2/3} ] [--set-timeout time-limit-for-task] [-t,--target-os target-os]

    OPTIONS
        -i, --input INPUT_PATH
            [Mandatory option] Specifies the path of the software package to be scanned.
        -o, --output OUTPUT_PATH
            Specify the path for storing the scan report and the file name. By default, the file is stored in the current path(pwd) and its name is in the format of function name_timestamp.
        -t, --target-os {bclinux7.6,bclinux7.7,centos7.4,centos7.5,centos7.6,centos7.7,centos8.0,centos8.1,centos8.2,debian10,deepinv15.2,euleros2.8,isoft5.1,kylinv10sp1,kylinv10sp2,linxos6.0.90,linxos-el6.0.99,linxos6.0.100,neokylinv7u5,neokylinv7u6,openeuler20.03,openeuler20.03sp1,openeuler20.03sp2,openeuler20.03sp3,openeuler22.03,openeuler24.03,openeuler24.03sp1,susesles15.1,ubuntu18.04.x,ubuntu20.04.x,uos20-1020e,uos20sp1,uoseuler20,openeuler22.03sp3,openeuler22.03sp4,uos20-1060e,ctyunos22.06}
            Specifies the target OS for migration. The default value is the operating system of the tool deployment node.
        -l, --log-level {0,1,2,3}
            Specifies the log level of the current task, 0(DEBUG) | 1(INFO) | 2(WARNING) | 3(ERROR). The default value is 1(INFO).
        -r, --report-type {all,json,html,csv}
            Specify the report type for the scan report. The default value is all.
        --set-timeout <min>
            Specifies the timeout period of a task. By default, the timeout period is not set.

    EXAMPLE
        # Scan a JAR Package and generate scanning reports.
        devkit porting pkg-mig -i /home/porting/project.jar -t openeuler22.03
```

### 3.2.2 使用命令行进行软件迁移评估

#### 命令功能
对软件包（非源码包）和已安装的软件进行扫描分析，提供迁移评估报告。

#### 命令格式
执行以下命令，查看所有命令参数说明。
```shell
devkit porting pkg-scan -i,--input path-to-package [-o,--output path-to-output] [-b,--build-tool {make,cmake}] [-r,--report-type {all/json/html/csv}] [-l,--log-level {0,1,2,3} ] [--set-timeout time-limit-for-task] [-t,--target-os target-os]
```

#### 参数说明
**表1 参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-i/--input</td>
    <td>package_path</td>
    <td>
      待扫描的软件包路径，若存在多个扫描路径需使用英文逗号分割。<br>
      必选参数。例如：home/test1.jar, /home/test2.jar。
    </td>
  </tr>
  <tr>
    <td>-t/--target-os</td>
    <td>target-os</td>
    <td>
      待扫描的目标操作系统。<br>
      可选参数。
    </td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>output_path</td>
    <td>
      报告存放路径。<br>
      可选参数。<br>
      报告默认存放在当前执行路径下，名称默认为“特性名称_时间戳”。
    </td>
  </tr>
  <tr>
    <td>--set-timeout</td>
    <td>time</td>
    <td>
      任务超时时间。<br>
      可选参数。<br>
      默认无超时时间，任务将持续执行直到结束。
    </td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      任务日志级别。<br>
      可选参数。<br>
      0（DEBUG）、1（INFO）、2（WARNING）、3（ERROR），默认为1（INFO）。
    </td>
  </tr>
  <tr>
    <td>-r/--report-type</td>
    <td>all,json,html,csv</td>
    <td>
      扫描报告的格式。<br>
      可选参数。<br>
      默认为all，即默认生成json、html、csv三种报告。
    </td>
  </tr>
</table>

#### 使用实例
此处以以下命令为例，请根据实际情况替换成实际需要扫描的软件包路径
```shell
devkit porting pkg-mig -i impala-2.9.0+cdh5.12.1+0-1.cdh5.12.1.p0.3.el7.x86_64.rpm -c make
```
返回信息如下，并输出报告。
```shell
Using the local system as target os: openeuler20.03sp1
Configuration:
    Task name: 20240229094505
    Scanned time: 2024-02-29 09:45:05
    Software package path: /opt/DevKit-CLI-CI_VERSION_NUMBER-Linux-Kunpeng/impala-2.9.0+cdh5.12.1+0-1.cdh5.12.1.p0.3.el7.x86_64.rpm
    Software installation path: None
    Target OS: openeuler20.03sp1
    Target OS Kernel Version: 4.19.90
 
Summary:
    Compatible: 6, To be Verified: 25, Total Dependencies: 31
 For the detailed information, please check: /opt/DevKit-CLI-CI_VERSION_NUMBER-Linux-Kunpeng/pkg-mig_20240229014505_dacb
```
#### 输出报告说明
**表2 迁移评估任务输出报告参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>说明</th>
  </tr>
  <tr>
    <td>配置信息</td>
    <td>显示软件安装包存放路径或软件包名称或x86上已安装软件路径，目标操作系统和目标系统内核版本以及评估结果。</td>
  </tr>
  <tr>
    <td>与架构相关的依赖库文件</td>
    <td>
      显示SO文件。<br>
      - 针对兼容鲲鹏平台的动态库、静态库文件、软件包、可执行文件、Jar包等，用户可以直接单击处理建议中的“下载”，下载鲲鹏平台可用的文件，然后进行替换，或者下载鲲鹏版本源码，直接编译。对于一些未开源的依赖文件，工具无法提供下载URL，请自行获取后进行替换。<br>
      - 针对鲲鹏平台兼容性未知的文件，请先在鲲鹏平台上验证。若不兼容，请联系供应方获取鲲鹏兼容版本，或获取源码并编译成鲲鹏兼容版本，或使用其他方案替代。<br>

```text
说明：如果“处理建议”列中提示“该文件已兼容鲲鹏平台”，则表示分析的对象是已迁移过的软件包或源码包且该x86依赖文件已在鲲鹏平台有对应鲲鹏依赖文件。
```
   </td>
  </tr>
</table>

## 3.3 源码迁移

### 3.3.1 命令参数说明
源码迁移功能分析用户C/C++/ASM/Fortran/Go/解释型语言软件的可迁移性。

#### 命令功能
查看源码迁移特性所有命令参数。

#### 命令格式
```shell
devkit porting src-mig -h
```
#### 使用实例
执行以下命令，查看所有命令参数说明。
```shell
devkit porting src-mig -h
```
返回信息如下：
```shell
    OVERVIEW
        Run this command to check and analyze source code files such as C, C++, ASM, Fortran, interpreted language, and assembly, locate the code to be migrated, and provide migration guidance.

    USAGE
        devkit porting src-mig -i,--input path-to-source-code -c,--command 'string of compiling command line' [-s,--source-type {c|c++|asm|fortran|go| interpreted}*] [-t,--target-os target-os] [-p,--compiler compiler-version] [-f,--fortran-compiler fortran-compiler-version] [-o,--output path-to-output] [-b,--build-tool {make,cmake,automake,go,bazel,blade}] [-r,--report-type {all/json/html/csv}] [-l,--log-level {0/1/2/3} ] [--set-timeout time-limit-for-task] [--ignore path-to ignore-file] [--macro MACRO] [--keep-going {True,False}]

    OPTIONS
        -i, --input INPUT_PATH
            [Mandatory option] Specifies the folder or package path of the source code to be scanned.
        -o, --output OUTPUT_PATH
            Specify the path for storing the scan report and the file name. By default, the file is stored in the current path(pwd) and its name is in the format of function name_timestamp.
        -b, --build-tool {make,cmake,automake,go,bazel,blade}
            Specify the building tool. The default value is make.
        -c, --cmd COMMAND
            Specifies the build command of the source code. If the source code to be scanned contains only interpreted languages, this parameter is optional. If the build tool is Make or CMake and the -c option is either not specified or mismatched, all files will be scanned.
        -s, --source-type {c|c++|asm|fortran|go|interpreted}*
            Specifies the type of source code to be scanned. The default value is ‘c/c++/asm’
        -t, --target-os {centos7.6,neokylinv7u5,neokylinv7u6,deepinv15.2,ubuntu18.04.x,linxos6.0.90,linxos-el6.0.99,linxos6.0.100,debian10,susesles15.1,euleros2.8,centos7.4,centos7.5,centos7.7,openeuler20.03,openeuler22.03,openeuler20.03sp1,openeuler20.03sp2,openeuler20.03sp3,centos8.0,centos8.1,centos8.2,uos20sp1,kylinv10sp1,kylinv10sp2,ubuntu20.04.x,uoseuler20,uos20-1020e,bclinux7.6,bclinux7.7,isoft5.1,openeuler22.03sp1,openeuler22.03sp3,openeuler22.03sp4,openeuler24.03lts,openeuler24.03sp1,uos20-1050e,uos20-1060e,kylinsecos3.4,kylinv10sp3,ctyunos22.06} Specifies the target OS for migration. The default value is the operating system of the tool deployment node.
        -p, --compiler {bisheng compiler2.1.0,bisheng compiler2.3.0,bisheng compiler2.4.0,bisheng compiler2.5.0,bisheng compiler2.5.0.1,bisheng compiler3.0.0,bisheng compiler3.1.0,bisheng compiler3.2.0,bisheng compiler4.0.0,bisheng compiler4.1.0,bisheng compiler4.2.0,gcc4.8.5,gcc4.9.3,gcc5.1.0,gcc5.2.0,gcc5.3.0,gcc5.4.0,gcc5.5.0,gcc6.1.0,gcc6.2.0,gcc6.3.0,gcc6.4.0,gcc6.5.0,gcc7.1.0,gcc7.2.0,gcc7.3.0,gcc7.4.0,gcc8.1.0,gcc8.2.0,gcc8.3.0,gcc9.1.0,gcc9.2.0,gcc9.3.0,gcc10.1.0,gcc10.2.0,gcc10.3.0,gcc10.3.1,gcc12.3.0,gcc for openeuler2.3.7,gcc for openeuler2.3.8,gcc for openeuler3.0.1,gcc for openeuler3.0.2}
            Specifies the compiler version used for compiling source code. The C/C++/ASM and GO languages share the same compiler version. The default value is the version of the compiler that comes with the target operating system.
        -f, --fortran-compiler {flang2.1.0, flang2.3.0, flang2.4.0, flang2.5.0, flang2.5.0.1, flang3.0.0, flang3.1.0, flang3.2.0, gfortran7, gfortran8, gfortran9}
            Specifies the version of the compiler that compiles the fortran source code. The default value is flang2.5.0.1
        -l, --log-level {0,1,2,3}
            Specifies the log level of the current task, 0(DEBUG) | 1(INFO) | 2(WARNING) | 3(ERROR). The default value is 1(INFO).
        -r, --report-type {all,json,html,csv}
            Specify the report type for the scan report. The default value is all.
        --set-timeout <min>
            Specifies the timeout period of a task. By default, the timeout period is not set.
        --ignore [CONFIG_PATH]
            Masking scanning rule items. By default, the ignore.json file in the tool path is read. You can specify the path of the masking rule configuration file.
            The path of the configuration file (ignore_rules.json) is {install_path}/config/ignore_rules.json
            Enter the keywords to be filtered in the source code in src_list and dependency file names to be filtered in lib_list. For instance,
            {
                'src_list': [' -march', ' -mpopcnt'],
                'lib_list': ['libz.so']
            }
        --macro MACRO         X86 macros
        --keep-going {True,False}    The values of Continue scanning with keyword arm/arm64/aarch64.

    EXAMPLE
        # Scan C/C++ Project and generate scanning reports
        devkit porting src-mig -i /home/porting/cplusproject -s ‘c,c++,asm‘ -b make -c ‘make all‘ -p gcc4.8.5
        # Scan Java/Python Project and generate scanning reports
        devkit porting src-mig -i /home/porting/javaproject -s ‘interpreted‘
        # Scan Fortran Project and generate scanning reports
        devkit porting src-mig -i /home/porting/fortranproject -s ‘fortran‘ -b make -c ‘make all‘ -f gfortran9
        # Scan Go Project and generate scanning reports
        devkit porting src-mig -i /home/porting/fortranproject -s ‘fortran‘ -b go -c ‘go build‘ -f gfortran9
        # Scan Java/Python projects that contain C/C++ source code and generate scanning reports.
        devkit porting src-mig -i /home/porting/javaproject -s ‘c,c++,asm,interpreted‘ -b make -c ‘make all‘ -p gcc4.8.5
        # Scan the C/C++ project that contains the Fortran source code and generate scanning reports.
        devkit porting src-mig -i /home/porting/cplusproject -s ‘c,c++,asm,fortran‘ -b make -c ‘make all‘ -p gcc4.8.5 -f gfortran9
        # Scan C/C++ projects that are built by bazel and generate scanning reports.
        devkit porting src-mig -i /home/porting/cplusproject -s 'c,c++,asm,interpreted' -b bazel -p gcc4.8.5
        # Scan C/C++ projects that are built by blade and generate scanning reports.
        devkit porting src-mig -i /home/porting/cplusproject -s 'c,c++,asm,interpreted' -b blade -p gcc4.8.5
```

### 3.3.2 使用命令行进行源码迁移

#### 命令功能
在终端环境下分析用户C/C++/ASM/Fortran/Go/解释型语言软件的可迁移性。

#### 命令格式

```shell
devkit porting src-mig {-i INPUT_PATH | --input INPUT_PATH} [-c 'command' | --cmd 'command'] [-s {c|c++|asm|fortran|go| interpreted}* | --source-type {c|c++|asm|fortran|go| interpreted}*] [-t targe_os | --target-os targe_os] [-p compiler_version | --compiler compiler_version] [-f  fortran-compiler-version | --fortran-compiler fortran-compiler-version] [-o OUTPUT_PATH | --output OUTPUT_PATH] [-b {make,cmake,automake,go,bazel,blade} | --build-tool {make,cmake,automake,go,bazel,blade}] [-r {all,json,html,csv} | --report-type {all,json,html,csv}] [-l {0,1,2,3} | --log-level {0,1,2,3}] [--set-timeout TIMEOUT] [--ignore ignore_file] [--ignore-path IGNORE_PATH] [--macro MACRO] [--keep-going {True,False}]
```

#### 参数说明
**表1 参数说明**

<table>
  <tr>
    <td>参数</td>
    <td>参数选项</td>
    <td>参数说明</td>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>-</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-i/--input-path</td>
    <td>-</td>
    <td>必选参数，待扫描源码的文件夹或压缩包所在路径，若存在多个扫描路径需使用空格分隔。</td>
  </tr>
  <tr>
    <td>-b/--build-tool</td>
    <td>make/cmake/automake/go/bazel/blade</td>
    <td>构建工具，默认make。</td>
  </tr>
  <tr>
    <td>-c/--cmd</td>
    <td>-</td>
    <td>源码的构建命令，需使用单/双引号引起来。若命令包含空格，需使用单引号。</td>
  </tr>
  <tr>
    <td>-s/--source-type</td>
    <td>c/c++/asm/fortran/go/interpreted</td>
    <td>待扫描源码类型，默认为'c,c++,asm'。</td>
  </tr>
  <tr>
    <td>-t/--target-os</td>
    <td>详见-h帮助信息。</td>
    <td>迁移的目标操作系统，如果用户不输入则默认为当前操作系统。</td>
  </tr>
  <tr>
    <td>-p/--compiler</td>
    <td>详见-h帮助信息。</td>
    <td>编译器版本，c/c++/asm和go语言使用相同的编译器版本。默认为目标操作系统附带的编译器版本。</td>
  </tr>
  <tr>
    <td>-f/--fortran-compiler</td>
    <td>详见-h帮助信息。</td>
    <td>fortran代码的编译器版本，默认为flang2.5.0.1。</td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>-</td>
    <td>扫描报告的存放路径，默认存放在当前执行路径下，报告名称为特性名称_时间戳。</td>
  </tr>
  <tr>
    <td>--set-timeout</td>
    <td>-</td>
    <td>任务超时时间，单位为分钟，若执行时间超过超时时间则退出执行。默认无超时时间，任务将持续执行直到结束。</td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0/1/2/3</td>
    <td>设置日志级别，默认为1。</td>
  </tr>
  <tr>
    <td>-r/--report-type</td>
    <td>all/json/html/csv</td>
    <td>扫描报告的格式，默认为all。</td>
  </tr>
  <tr>
    <td>--ignore</td>
    <td>/opt/ignore_rules.json</td>
    <td>可通过配置屏蔽扫描规则文件，屏蔽不影响扫描结果的信息。默认读取工具路径下的ignore_rules.json文件，具体格式请参见屏蔽扫描规则文件说明（--ignore）。</td>
  </tr>
  <tr>
    <td>--ignore-path</td>
    <td>-</td>
    <td>指定需要屏蔽扫描的源码文件或源码文件夹所在路径，若存在多个路径需使用空格分隔。</td>
  </tr>
  <tr>
    <td>--macro</td>
    <td>-</td>
    <td>自定义x86平台宏。输入自定义宏时，多个宏之间请用“;”进行分隔。</td>
  </tr>
  <tr>
    <td>--keep-going</td>
    <td>True/False</td>
    <td>发现arm/arm64/aarch64关键字是否继续扫描。</td>
  </tr>
</table>

#### 使用实例
此处以分析wtdbg2-2.5工程代码并输出csv格式、json格式、HTML格式的分析报告为例，请根据实际情况将“wtdbg2-2.5”替换成实际需要扫描的代码路径。
```shell
devkit porting src-mig -i wtdbg2-2.5 -c make
```

返回信息如下，在返回信息中输入普通用户密码（新建用户首次使用时需要输入密码）。
```shell
Using the local system as target os: openeuler20.03sp1
Current progress: ################################# [100%]
Scanned time: 2025/03/31 11:23:07

Configuration:
    Scan code path: /home/TestData/wtdbg2-2.5/
    Compiler: GCC 4.8.5
    Interpreted(Python, Java, Scala): False
    Go: False
    Target OS: openeuler20.03sp1, kernel: 4.19.90
    Software make command: make
    Source Need Migrated: Need Migrated

File scan statistics:
    Total files: 35
    Scanned 34 C/C++ files, 1 Makefile/CMakeLists.txt/Automake related files, total 3 files need to be migrated.
    Scanned 0 pure assembly files, 0 pure assembly files to be migrated.
    Scanned 0 Go files, 0 Go files to be migrated.
    Scanned 0 python files, 0 python files to be migrated.
    Scanned 0 java files, 0 java files to be migrated.
    Scanned 0 scala files, 0 scala files to be migrated.
    Scanned 0 bazel files, 0 bazel files to be migrated.
    Scanned 0 blade files, 0 blade files to be migrated.

Dependency file statistics:
    Adaptable for Compatibility: 1, To be Modified: 0, Total Dependencies: 1

Source file statistics:
    Files to be modified: 3
    Lines to be modified: 17
    Total 16 rules and 0 suggestions.
    Estimated transplant workload: 0.1 person/months.(C/C++/Fortran/Go, 500Line/PM; ASM, 250Line/PM)

For the detailed information, please check:
/home/DevKit_Software/src-mig_20250331032307_TYjAhO_zh.json
/home/DevKit_Software/src-mig_20250331032307_TYjAhO_zh.csv
/home/DevKit_Software/src-mig_20250331032307_TYjAhO.html
```

```text
[说明]
- 不同的目标操作系统支持的SO库不一样，所以分析报告会有差异。
```

#### 输出说明
**表2 迁移评估任务输出报告参数说明**
<table>
  <tr>
    <th colspan="2">参数</th>
    <th>说明</th>
  </tr>
  <tr>
    <td colspan="2">Scanned time</td>
    <td>扫描时间。</td>
  </tr>
  <tr>
    <td rowspan="9">Configuration</td>
    <td>Source Code File Path</td>
    <td>扫描的源码文件存放路径。</td>
  </tr>
  <tr>
    <td>Target OS</td>
    <td>目标操作系统。</td>
  </tr>
  <tr>
    <td>Target OS Kernel Version</td>
    <td>内核版本。</td>
  </tr>
  <tr>
    <td>Compiler Version</td>
    <td>编译器版本。</td>
  </tr>
  <tr>
    <td>Build Tool</td>
    <td>构建工具。</td>
  </tr>
  <tr>
    <td>Software make command</td>
    <td>编译命令。</td>
  </tr>
  <tr>
    <td>Interpreted(Python,Java,Scala)</td>
    <td>
      分析对象是否包括解释型语言文件。<br>
      True：是 False：否。
    </td>
  </tr>
  <tr>
    <td>Go</td>
    <td>
      分析对象是否包括Go语言文件。<br>
      True：是 False：否。
    </td>
  </tr>
  <tr>
    <td>Custom x86 Macros</td>
    <td>自定义x86宏。</td>
  </tr>
  <tr>
    <td rowspan="10">Summary</td>
    <td>Compatible: x, To be Verified: x, Total Dependencies: x</td>
    <td>显示兼容鲲鹏平台的文件数，待验证文件数，依赖库文件总数。</td>
  </tr>
  <tr>
    <td>Source Need Migrated</td>
    <td>
      源码是否需要迁移。<br>
      Yes：是 No：否。
    </td>
  </tr>
  <tr>
    <td>Scanned xx C/C++/Fortran  files, xx Makefile/CMakeLists.txt/Automake related files, total xx files need to be migrated.</td>
    <td>显示需要迁移的C/C++/Fortran文件和Makefile/CMakeLists.txt/Automake related文件总数以及文件个数。</td>
  </tr>
  <tr>
    <td>Total xx lines C/C++/Makefile/CMakeLists.txt/Automake code and xx lines embedding ASM code need to be migrated</td>
    <td>显示源码总行数以及需要迁移的内联汇编代码行数。</td>
  </tr>
  <tr>
    <td>Scanned xx pure assembly files, xx pure assembly files to be migrated.</td>
    <td>显示全汇编文件总数以及需要迁移的汇编文件个数和汇编代码行数。</td>
  </tr>
  <tr>
    <td>Scanned x Go files, total x Go files xx lines need to be migrated.</td>
    <td>显示Go文件总数一级需要迁移的Go文件个数和代码行数。</td>
  </tr>
  <tr>
    <td>Scanned xx python files, total xx files xx lines need to be migrated.</td>
    <td>显示Python文件总数以及需要迁移的Python文件个数和Python代码行数。</td>
  </tr>
  <tr>
    <td>Scanned xx java files, total xx files xx lines need to be migrated.</td>
    <td>显示Java文件总数以及需要迁移的Java文件个数和Java代码行数。</td>
  </tr>
  <tr>
    <td>Scanned xx scala files, total xx files xx lines need to be migrated.</td>
    <td>显示Scala文件总数以及需要迁移的Scala文件个数和Scala代码行数。</td>
  </tr>
  <tr>
    <td>Estimated transplant workload: xx person/months.(C/C++/Fortran/Go, 500Line/PM; ASM, 250Line/PM)</td>
    <td>
      显示源码迁移预估人力（x/人月）。<br>
      预估标准：1人月迁移工作量=500行C/C++/Fortran/Go源代码，或250行汇编代码。</td>
  </tr>
  <tr>
    <td colspan="2">Architecture-related Dependencies</td>
    <td>
        显示依赖库文件扫描的详细信息：<br>
        - File Name：文件名称<br>
        - File Type：文件类型<br>
        - Analysis Results：分析结果<br>
        - Handling Suggestions：处理建议<br>
        - URL：下载地址
    </td>
  </tr>
  <tr>
    <td colspan="2">Source files scan details are as follows:</td>
    <td>
        显示源文件分析报告的详细信息：<br>
        - filename：扫描文件全路径。<br>
        - filetype：扫描文件的类型。<br>
        - line number：函数在文件中的行号。<br>
        - rows：函数在文件中的总行数。<br>
        - category：关键字所属类型。<br>
        - keyword：关键字名称。<br>
        - suggestion：迁移建议或者提示建议。<br>
        - description：关键字用法描述。
    </td>
  </tr>
</table>

# 4 系统迁移

## 4.1 命令参数说明
鲲鹏DevKit提供命令行工具对系统迁移中的应用进行信息分析。

### 命令功能
查看所有命令参数说明。

### 命令格式
Linux环境
```shell
devkit sys-mig -h
```

Windows环境
```shell
.\sys-mig.exe -h
```

### 使用实例
以Linux环境为例，运行以下命令，查看所有命令参数说明。
```shell
devkit sys-mig -h
```
返回信息如下：
```shell
    USAGE
        devkit sys-mig [-c {stmt|sbom|mvn_analyse}] [-cf INPUT_PATH] [-d INPUT_PATH] [-o INPUT_PATH]
                                 [-t FILE_PATH] [-f {html|json}] [-e {version|checkOutPath}] [-l {0,1,2,3}]

    OPTIONS
        -h, --help
            Show this help message and exit.

        -c, --command {stmt,sbom,mvn_analyse}
            Type of information to be collected. The options are stmt (default) ,sbom and mvn_analyse. stmt generates a CSV report, sbom generates a detailed HTML or JSON report and mvn_analyse generates an HTML report.

        -cf, --config <file>
            Configuration file path of the input parameter.

        -d, --directory <path> [<path> ...]
            Directory of scanning for collected information. You can enter multiple directories (the current directory by default).
            Separate multiple directories with spaces(Example: -d /home/jar /home/ear).
            If the name of the folder to be scanned contains spaces, use single quotation marks(') to mark the parameter(Example: -d '/home/easy jar').

        -o, --output <path>
            Report output directory. (The default is the report directory where the binary file is located.)

        -t, --template <file>
            This parameter is used in stmt mode. Enter the template path of the CSV report. (By default, the CSV report is generated based on the built-in template.)
            For details about the template, see ./resources/stmt_template_default.csv.
            Built-in variables used in the template include ${cpuCores}, ${memory}, ${middleware}, ${dbType}, ${osSystem}, ${ip}, and ${hostName}, and they cannot be modified.

        -f, --format {html,json} [{html,json} ...]
            Format of the report generated in sbom mode. The options are HTML and json. You can select multiple report formats. The default value is HTML.
            Separate multiple reports with spaces(Example: -f html json).

        -e, --exclude-fields {version,checkOutPath} [{version,checkOutPath} ...]
            Parameters hidden in sbom mode. The optional parameters are version and checkOutPath, and they can be selected at the same time.
            Version indicates the component version number and checkOutPath indicates the component checkout path.
            Separate multiple parameters with spaces(Example: -e version checkOutPath).

        -l, --log-level {0,1,2,3}
            Log level. The options are 0(DEBUG), 1(INFO), 2(WARNING), and 3(ERROR). The default value is 1(INFO).

        -v, --version
            Program version information.

    EXAMPLE
        devkit sys-mig -c stmt -cf /home/config.conf -d /usr/local /usr/jar -o /home/report -t /home/template/stmt_template_default.csv -l 1
        devkit sys-mig -c sbom -cf /home/config.conf -d /home/jar -o /home/report -f html -l 1
        devkit sys-mig -c mvn_analyse -cf /home/config.conf -d /home/mvn_analyse_test_plugin -o /home/report -l 1
```

## 4.2 使用命令行进行系统迁移应用信息收集

### 命令功能
使用命令通过终端工具进行系统迁移应用信息收集。

### 命令格式
Linux环境
```shell
devkit sys-mig -c|--command <stmt/sbom/mvn_analyse> -cf|--config <configure_file_path> -d|--directory <scan_path> -t|--template <stmt_template_path> -o|--output <report_dir> -f|--format <html/json> -e|--exclude-fields <version/checkOutPath> -l|--log-level <0,1,2,3> -v|--version -h|--help
```

### 参数说明
**表4-1 参数说明**

<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-c/--command</td>
    <td>stmt/sbom/mvn_analyse</td>
    <td>
      收集信息的模式。<br>
        stmt（默认）：收集台账信息，可生成csv报告。<br>
        sbom：收集sbom信息，可生成html或json报告。<br>
        mvn_analyze：Maven工程源码迁移分析，可生成html报告。
    </td>
  </tr>
  <tr>
    <td>-cf/--config</td>
    <td>configure_file_path</td>
    <td>输入参数配置文件路径。</td>
  </tr>
  <tr>
    <td>-d/--directory</td>
    <td>scan_path</td>
    <td>输入扫描文件目录，支持输入多个目录，多个目录间以空格分隔。</td>
  </tr>
  <tr>
    <td>-t/--template</td>
    <td>stmt_template_path</td>
    <td>stmt模式参数，输入台账扫描结果模板路径，默认按照程序内置模板生成扫描结果。</td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>report_dir</td>
    <td>报告输出目录，默认为二进制所在report目录。</td>
  </tr>
  <tr>
    <td>-f/--format</td>
    <td>html/json</td>
    <td>sbom模式参数，输入生成报告格式，支持选择html、json格式，可以选择多个报告格式，默认为HTML格式，多个报告格式以空格间隔。</td>
  </tr>
  <tr>
    <td>-e/--exclude-fields</td>
    <td>version/checkOutPath</td>
    <td>
      sbom模式参数，表示需要隐藏的参数信息，可选参数范围：version和checkOutPath，支持同时选择。<br>
      version表示成分版本号，checkOutPath表示成分检出路径，多个参数信息以空格间隔
    </td>
  </tr>
  <tr>
    <td>-v/--version</td>
    <td>--</td>
    <td>展示程序版本信息，无输入参数。</td>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>帮助查询，无输入参数。</td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      任务日志级别。<br>
      可选参数。<br>
      0（DEBUG）、1（INFO）、2（WARNING）、3（ERROR），默认为1（INFO）。
    </td>
  </tr>
</table>

### 使用实例
此处以分析sys-mig/resources目录下的sysmig_default.conf并输出csv格式的分析报告为例，请根据实际情况将“sys-mig/resources/sysmig_default.conf”替换成实际需要扫描的配置文件路径。
```shell
devkit sys-mig -c stmt -cf sys-mig/resources/sysmig_default.conf
```
返回信息如下，输出的报告为/home/stmt_xx.xx.xx.xx_20240307142402.csv。
```shell
[2024-03-07 14:24:02,424] [INFO] Start to execute the command: devkit porting sys-mig -c stmt -cf porting/resources/sysmig_default.conf -d /usr/local -o /home -t /home/stmt_template_default.csv -l 0
[2024-03-07 14:24:02,425] [INFO] Creating file indexing...
[2024-03-07 14:24:04,580] [INFO] Parsing...
[2024-03-07 14:24:04,580] [INFO] Start Scanning stmt information.
[2024-03-07 14:24:04,581] [INFO] Middleware binary start analysis.
[2024-03-07 14:24:06,513] [INFO] Middleware binary end of analysis.
[2024-03-07 14:24:06,513] [INFO] Middleware binary start analysis.
[2024-03-07 14:24:06,576] [INFO] Middleware package end of analysis.
[2024-03-07 14:24:06,591] [INFO] csv report is created successfully. the file is located in /home/stmt_xx.xx.xx.xx_20240307142402.csv
```

### 配置文件使用说明
台账命令行配置文件模板，在命令行配置-cf或--config时生效。默认格式如下所示：
```shell
# DESCRIPTION
#     Configuration file template of the System Migration command line. It takes effect only when -cf or --config is executed.
#     To use this template, delete the template comments below the help information and set the parameters. Note that parameters in the command line take precedence
#     over those in the configuration file. If parameters have been set in the command line, the parameters in the configuration file do not take effect.
# OPTIONS
# command {stmt,sbom,mvn_analyse}
#     Type of information to be collected. The options are stmt(default), sbom and mvn_analyse. stmt generates a CSV report, sbom generates a detailed HTML or JSON report, and mvn_analyse generates an HTML report.
# directory <path> [<path> ...]
#     Directory of scanning for collected information. You can enter multiple directories (the current directory by default).
#     Separate multiple directories with spaces. If the name of the folder to be scanned contains spaces, use single quotation marks(') to mark the parameter.
# output <path>
#     Report output directory. (The default is the report directory where the binary file is located.)
# template <file>
#     This parameter is used in stmt mode. Enter the template path of the CSV report. (By default, the CSV report is generated based on the built-in template.)
#     For details about the template, see ./resources/stmt_template_default.csv.
#     Built-in variables used in the template include ${cpuCores}, ${memory}, ${middleware}, ${dbType}, ${osSystem}, ${ip}, and ${hostName}, and they cannot be modified.
# format {html,json} [{html,json} ...]
#     Format of the report generated in sbom mode. The options are HTML and json. You can select multiple report formats. The default value is HTML.
#     Separate multiple reports with spaces(Example: -f html json).
# exclude-fields {version,checkOutPath} [{version,checkOutPath} ...]
#     Parameters hidden in sbom mode. The optional parameters are version and checkOutPath, and they can be selected at the same time.
#     Version indicates the component version number and checkOutPath indicates the component checkout path. Separate multiple parameters with spaces.
# log-level {0,1,2,3}
#     Log level. The options are 0(DEBUG), 1(INFO), 2(WARNING), and 3(ERROR). The default value is 1(INFO).
# [stmt]
#     directory=
#     output=
#     template=
#     log-level=
# [sbom]
#     directory=
#     output=
#     format=
#     exclude-fields=#     log-level=
```

```text
[说明]
- 如需使用上述模板，请删除帮助信息下方模板内容的注释，并填写对应参数内容。
  例如：可将[stmt]或者[sbom]配置的注释符号删除，添加自己的配置使用。
- 命令行参数优先级高于配置文件，若命令行已填写参数，则配置文件中填写内容无效。
```

### stmt模式下模板使用示例
```shell
devkit sys-mig -c stmt -t template/stmt_tempalte_default.csv
```

```text
[说明]
-t/--template参数的默认模板位置为sys-mig/template/stmt_tempalte_default.csv。
其中template是一个csv文件，有两行数据。第一行是待搜索的信息，第二行是搜索信息对应的内部变量，可删除或更换位置，但不可修改。
```

### 输出报告说明
**表4-2 输出报告说明**
<table>
  <tr>
    <th>报告类型</th>
    <th>报告详细说明</th>
  </tr>
  <tr>
    <td>csv</td>
    <td>显示包含服务器数量、CPU核数、内存等结果信息。</td>
  </tr>
  <tr>
    <td>json</td>
    <td rowspan="2">
      - 系统成分扫描报告：包括扫描结果统计和系统文件成分的分析。<br>
      - 任务信息：包含报告生成时间和文件存放路径等基本信息。
    </td>
  </tr>
  <tr>
    <td>html</td>
  </tr>
</table>

## 4.3 使用命令行进行系统迁移Maven工程源码迁移分析信息收集

### 命令功能
使用命令通过终端工具进行Maven工程源码迁移分析，CLI通过mvn指令调取Maven插件，解析POM文件中依赖的jar兼容性，并生成HTML报告。

### 命令格式
Linux环境
```shell
devkit sys-mig -c|--command <stmt/sbom/mvn_analyse> -cf|--config <configure_file_path> -d|--directory <scan_path> -o|--output <report_dir> -l|--log-level <0,1,2,3> -v|--version -h|--help
```
Windows环境
```shell
.\sys-mig.exe -c|--command <stmt/sbom/mvn_analyse> -cf|--config <configure_file_path> -d|--directory <scan_path> -o|--output <report_dir> -l|--log-level <0,1,2,3> -v|--version -h|--help
```

### 参数说明
**表4-3 参数说明**

<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-c/--command</td>
    <td>stmt/sbom/mvn_analyse</td>
    <td>
        收集信息的模式。<br>
        stmt（默认）：收集台账信息，可生成csv报告。<br>
        sbom：收集sbom信息，可生成html或json报告。<br>
        mvn_analyze：Maven工程源码迁移分析，可生成html报告。
    </td>
  </tr>
  <tr>
    <td>-cf/--config</td>
    <td>configure_file_path</td>
    <td>支持通过配置文件方式输入参数，默认模板位置为sys-mig/resources/sysmig_default.conf</td>
  </tr>
  <tr>
    <td>-d/--directory</td>
    <td>scan_path</td>
    <td>输入扫描文件目录，支持输入多个目录，多个目录间以空格分隔。</td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>report_dir</td>
    <td>报告输出目录，默认为二进制所在report目录。</td>
  </tr>
  <tr>
    <td>-v/--version</td>
    <td>--</td>
    <td>展示程序版本信息，无输入参数。</td>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      设置日志级别，默认为1。<br>
      0：日志级别为DEBUG。<br>
      1：日志级别为INFO。<br>
      2：日志级别为WARNING。<br>
      3：日志级别为ERROR。
    </td>
  </tr>
</table>

### 使用实例
此处以分析服务器home目录下的指定Maven工程，并输出html式的分析报告为例，请根据实际情况将“/home/maven_analyse/mvn_analyse_test_plugin”替换成实际需要扫描的Maven工程路径。
```shell
devkit sys-mig -c mvn_analyse -d /home/maven_analyse/mvn_analyse_test_plugin -o /home/report -l 1
```
返回信息如下，输出的报告为/home/report/sys-mig_xx.xx.xx.xx_20250214135724/mvn_analyse.html。
```shell
[2025-02-14 13:57:24,732] [INFO] Start to execute the command: ./devkit sys-mig -cf /root/DevKit-Sys-Mig-CLI-25.0.0-Linux-Kunpeng/sys-mig/resources/sysmig_default.conf -d /home/maven_analyse/mvn_analyse_test_plugin -o /home/report -l 1
[2025-02-14 13:57:24,732] [INFO] Creating file indexing...
[2025-02-14 13:57:24,732] [INFO] Parsing...
[2025-02-14 13:57:24,733] [INFO] Start Scanning maven information.
[2025-02-14 13:57:24,934] [INFO] The Maven version passes the check: 3.8.8
[2025-02-14 13:57:26,501] [INFO] The output of the get_local_repo_cmd is: /root/.m2/repository

[2025-02-14 13:57:28,064] [INFO] Install jar success
[2025-02-14 13:57:28,064] [INFO] Start to analyse maven dependencies in /home/maven_analyse/mvn_analyse_test_plugin, please wait.
[2025-02-14 13:57:31,386] [INFO] The output of the plugin in /home/maven_analyse/mvn_analyse_test_plugin:

Html report is created successfully. The file is located in /home/report/sys-mig_xx.xx.xx.xx_20250214135724/mvn_analyse.html
```

### 配置文件使用说明
Maven工程源码迁移分析命令行配置文件模板，在命令行配置-cf或--config时生效。默认格式如下所示：
```shell
# DESCRIPTION
#     Configuration file template of the System Migration command line. It takes effect only when -cf or --config is executed.
#     To use this template, delete the template comments below the help information and set the parameters. Note that parameters in the command line take precedence
#     over those in the configuration file. If parameters have been set in the command line, the parameters in the configuration file do not take effect.
# OPTIONS
# command {stmt,sbom,mvn_analyse}
#     Type of information to be collected. The options are stmt (default), sbom and mvn_analyse. stmt generates a CSV report, sbom generates a detailed HTML or JSON report, and mvn_analyse generates an HTML report
# directory <path> [<path> ...]
#     Directory of scanning for collected information. You can enter multiple directories (the current directory by default).
#     Separate multiple directories with spaces. If the name of the folder to be scanned contains spaces, use single quotation marks(') to mark the parameter.
# output <path>
#     Report output directory. (The default is the report directory where the binary file is located.)
# log-level {0,1,2,3}
#     Log level. The options are 0(DEBUG), 1(INFO), 2(WARNING), and 3(ERROR). The default value is 1(INFO).
# [mvn_analyse]
#     directory=
#     output=
#     log-level=
```

```text
[说明]
- 如需使用上述模板，请删除帮助信息下方模板内容的注释，并填写对应参数内容。
  例如：可将[mvn_analyse]配置的注释符号删除，添加自己的配置使用。
- 命令行参数优先级高于配置文件，若命令行已填写参数，则配置文件中填写内容无效。
```

### 输出报告说明
**表4-4 输出报告说明**
<table>
  <tr>
    <th>报告类型</th>
    <th>报告详细说明</th>
  </tr>
  <tr>
    <td>html</td>
    <td>
      - Maven工程源码迁移分析扫描报告：包括扫描结果统计和处理建议。<br>
      - 任务信息：包含报告生成时间和文件存放路径等基本信息。
    </td>
  </tr>
</table>

## 4.4 配置扫描规则

系统迁移在进行台账扫描和成分信息扫描时，支持通过配置扫描规则，识别新增软件。

### 配置扫描规则

默认扫描规则配置文件位于二进制目录下sys-mig/resources/sysmig_disk_scan_classifier.json，示例如下：

```
{
  "linux_binary_classifiers": [
    {
      "cli_category": "RUNTIME_JAVA",
      "category": 3,
      "file_glob": "**/java",
      "version_pattern": "(?m)(\\x00java\\x00|\\x00|\\x00-Djava.class.path=%s)(?P<release>[0-9]+[.0-9]*(\\x00)+)?(?P<version>\\d+(\\.\\d)+[^\\x00]+)(\\x00openjdk)?(\\x00java)?\\x00",
      "version_file": "../release",
      "package": "JDK",
      "supplier": "JDK",
      "type": "BINARY",
      "metadata_type": "JAVA_RUNTIME_BINARY",
      "company_type": "开源",
      "relative_directory_hierarchy": "../"
    },  
    ...
  ],
  "middleware_jar_classifiers": [
    {
      "cli_category": "MIDDLEWARE",
      "category": 3,
      "file_glob": "**/weblogic.jar",
      "version_pattern": "(?m)Implementation-Version: (?P<version>[0-9]+[.0-9]*)",
      "version_file": "MANIFEST.MF",
      "package": "WebLogic",
      "supplier": "Oracle Corporation",
      "type": "BINARY",
      "metadata_type": "MIDDLEWARE_WEB_WEBLOGIC",
      "company_type": "商业",
      "relative_directory_hierarchy": "../../../../../"
    },  
    ...
  ],
  "win_binary_classifiers": [
    {
      "cli_category": "RUNTIME_JAVA",
      "category": 3,
      "classify": "java_jdk_binary",
      "file_glob": "**/java.exe",
      "version_pattern": "(?m)\\x00openjdk\\x00java\\x00(?P<release>[0-9]+[.0-9]*)\\x00(?P<version>[0-9]+[^\\x00]+)\\x00",
      "package": "JDK",
      "supplier": "JDK",
      "type": "BINARY",
      "metadata_type": "JAVA_RUNTIME_BINARY_OPENJDK",
      "company_type": "开源",
      "relative_directory_hierarchy": "../"
    },   
    ...
  ]
}
```

包含以下类型：

- linux_binary_classifiers：Linux系统下，特征文件为二进制文件、文本文件等，非压缩文件的软件。
- middleware_jar_classifiers：Linux系统下，特征文件为jar包形式，需要解压的软件。
- win_binary_classifiers：Windows系统下，特征文件为二进制文件、文本文件等，非压缩文件的软件。

### 填写字段说明

| 字段名                       | 参数选项                                              | 是否必填 | 类型    | 描述                                                         |
| ---------------------------- | ----------------------------------------------------- | -------- | ------- | ------------------------------------------------------------ |
| cli_category                 | APP_JAVA/RUNTIME_JAVA/MIDDLEWARE/DATABASE/HARDWARE/OS | 是       | string  | 软件类别，用于命令行报告结果展示。范围见附表1                |
| category                     | 1/2/3/4                                               | 是       | int     | 软件类别，用于Web端源成分采集功能。范围见附表2               |
| use_file_regex               | true/false                                            | 否       | boolean | 特征文件是否使用正则匹配，默认为false。值若为false：则file_glob需要以**/开头，然后填写具体文件路径；若为true：则file_glob需要配置对应的正则表达式。 |
| file_glob                    | --                                                    | 是       | string  | 特征文件，用于标识软件和匹配软件版本。例如：\*\*/nginx。说明：版本匹配优先级从高到低为：file_glob、version_file |
| version_pattern              | --                                                    | 是       | string  | 版本。正则表达式，对特征文件进行正则匹配，若无可填空字符串   |
| version_file                 | --                                                    | 否       | string  | 版本文件名，用于匹配版本。在归类为middleware_jar_classifiers时必填。文件中包含该款软件的版本信息 |
| package                      | --                                                    | 是       | string  | 软件官方名称，例如：Nginx                                    |
| supplier                     | --                                                    | 是       | string  | 软件厂商名，例如：Nginx, Inc                                 |
| type                         | BINARY                                                | 是       | string  | 软件类型，需要配置为BINARY                                   |
| metadata_type                | DATABASE_OTHER/MIDDLEWARE_WEB_OTHER                   | 是       | string  | 软件归类。数据库：DATABASE_OTHER；中间件：MIDDLEWARE_WEB_OTHER |
| company_type                 | 自有/开源/商业/--                                     | 是       | string  | 是否开源。                                                   |
| relative_directory_hierarchy | --                                                    | 是       | string  | 安装目录。通过file_glob找到的特征文件的相对路径。例如：安装目录为特征文件上层目录，则填写../。 |

**附表1 cli_category字段范围**

| 字段         | 含义     |
| ------------ | -------- |
| APP_JAVA     | Java应用 |
| RUNTIME_JAVA | JDK      |
| MIDDLEWARE   | 中间件   |
| DATABASE     | 数据库   |
| HARDWARE     | 硬件     |
| OS           | 操作系统 |

**附表2 category字段范围**

| 字段 | 含义     |
| ---- | -------- |
| 1    | 操作系统 |
| 2    | 数据库   |
| 3    | 中间件   |
| 4    | Java应用 |

# 5 亲和分析

## 5.1 命令行参数说明
鲲鹏DevKit提供终端客户端工具以在任意服务器的CLI模式下完成亲和分析。

### 命令功能
查看亲和分析所有命令参数。

### 命令格式
查看所有命令参数说明。
```shell
devkit advisor -h
```

### 使用实例
运行以下命令，查看所有命令参数说明。
```shell
devkit advisor -h
```
返回信息如下：
```shell
Usage: devkit advisor [-h|--help] TASK [ARGS]

The most commonly used devkit advisor sub tasks are:
    run-mode                Run the 64-bit running mode check task.
    addr-align              Run the address alignment of the structure task.
    cacheline               Run the cache line alignment check task.
    bc-gen                  Run the bc file generation task.
    mm-check                Run the memory mode check task.
    vec-check               Run the vectorization check task.
    affi-check              Run the affinity check task.
    matrix-check            Run the matricization check task.
    dr-check                Run the dynamic memory consistency check task.
    precision               Run the precision analysis task.
    knet                    Run the K-NET analysis tools task.

  See 'devkit advisor TASK -h/--help' for more information on a specific task.
```

## 5.2 64位运行模式检查

### 5.2.1 命令参数说明
64位运行模式检查就是将GCC4.8.5~GCC10.3.0版本原32位的应用迁移到64位平台上，进行迁移检查并给出修改建议。

#### 命令功能
查看64位运行模式检查所有命令参数。

#### 命令格式
```shell
devkit advisor run-mode -h
```

#### 使用实例
执行以下命令，查看所有命令参数说明。
```shell
devkit advisor run-mode -h
```
返回信息如下：
```shell
    OVERVIEW
        Run this command to identifies the 32-bit applications to be ported to the 64-bit platform and provides modification suggestions.

    USAGE
        devkit advisor run-mode  
        [-h | --help] 
        {-i INPUT_PATH | --input INPUT_PATH} 
        {-c COMMAND | --command COMMAND}
        [-o OUTPUT_PATH | --output OUTPUT_PATH]
        [-r {all,json,html,csv} | --report-type {all,json,html,csv}]
        [-l {0,1,2,3} | --log-level {0,1,2,3}] 
        [--set-timeout TIMEOUT]

    OPTIONS
        -h, --help
        Get help information and exit.
        
        -i, --input INPUT_PATH
        [Mandatory option] Specifies the folder of the source code to be scanned.
        
        -c, --command COMMAND
        [Mandatory option] Specifies the build command of the source code. Use " or ' to include commands. Use semicolons ; to separate multiple commands. Commands for setting environment variables or common variables are not supported.
        
        -o, --output OUTPUT_PATH
        Specify the path for storing the scan report and the file name.
        By default, the file is stored in the current path and its name is in the format of function name_timestamp_uuid(4-digit).
        
        -l, --log-level {0,1,2,3}
        Specifies the log level of the current task, 0(DEBUG) | 1(INFO) | 2(WARNING) | 3(ERROR). The default value is 1(INFO).
        
        -r, --report-type {all,json,html,csv}
        Specify the report type for the scan report. The default value is all.
        
        --set-timeout <min>
        Specifies the timeout period of a task. By default, the timeout period is not set.

    EXAMPLE
        # Scan a project and generate scanning reports.
        devkit advisor run-mode -i /home/advisor/project -c make
```

### 5.2.2 使用命令行进行64位运行模式检查

#### 命令功能
使用命令通过终端工具进行运行模式检查。

#### 命令格式
```shell
devkit advisor run-mode [-h | --help] {-i INPUT_PATH | --input INPUT_PATH} {-c COMMAND | --command COMMAND} [-o OUTPUT_PATH | --output OUTPUT_PATH] [-r {all,json,html,csv} | --report-type {all,json,html,csv}] [-l {0,1,2,3} | --log-level {0,1,2,3}] [--set-timeout TIMEOUT]
```

#### 参数说明
**表1 参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>-</td>
    <td>
      获取帮助信息。
    </td>
  </tr>
  <tr>
    <td>-i/--input</td>
    <td>input_path</td>
    <td>
      必选参数，待扫描的源码文件夹路径。<br>
    </td>
  </tr>
  <tr>
    <td>-c/--command</td>
    <td>command</td>
    <td>
       必选参数，源码构建命令。在服务器中正常执行的构建命令，若存在多个构建命令需使用英文分号分割并用英文双引号包住。命令中如有空格，也需要用英文双引号包住。<br>
       例如："mkdir build;cd build;cmake ..;make"。
    </td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>output_path</td>
    <td>
      扫描报告的存放路径，默认存放在当前执行路径下，报告名称为模块名称_时间戳。
    </td>
  </tr>
  <tr>
    <td>--set-timeout</td>
    <td>time</td>
    <td>
      任务超时时间，单位为分钟，若执行时间超过超时时间则退出执行。默认无超时时间，任务将持续执行直到结束。
    </td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      设置日志级别，默认为1。<br>
      0：日志级别为DEBUG。<br>
      1：日志级别为INFO。<br>
      2：日志级别为WARNING。<br>
      3：日志级别为ERROR。
    </td>
  </tr>
  <tr>
    <td>-r/--report-type</td>
    <td>all,json,html,csv</td>
    <td>
      扫描报告的格式，默认为all。<br>
      all：生成JSON、HTML、CSV三种格式报告。<br>
      json：生成JSON格式报告。<br>
      html：生成HTML格式报告。<br>
      csv：生成CSV格式报告。
    </td>
  </tr>
</table>

#### 使用实例
此处以扫描以下test005文件夹下源码，构建命令为make，扫描报告存放至“/opt/DevKit”路径且日志级别为DEBUG为例，请根据实际情况进行修改。
```shell
devkit advisor run-mode -i /opt/DevKit/workspace/devadmin/affinity/precheck/test005 -c make -o /opt/DevKit -l 0
```
返回信息如下，并输出报告。
```shell
Executing 64-bit Run Mode Check task, please wait...
Current progress: 
64-bit Run Mode Check task has been executed.
Environment cleared successfully.

Scanned time: 20240327163253
Scan status: Succeed. Some items are recommended to be modified.

Configuration:
     Source code file path: /opt/DevKit/workspace/devadmin/affinity/precheck/test005
     Compile command: make
     Log level: debug
     Report type: all
     Timeout interval setting: The timeout period is not set.

Summary:
      5 source files to be modified have been scanned. There are 8 recommended modifications, 8 lines of code need to be modified.

For the detailed information, please check:
    /opt/DevKit/mode_check_20240327163253_826a.json
    /opt/DevKit/mode_check_20240327163253_826a.html
    /opt/DevKit/mode_check_20240327163253_826a.csv
```

#### 输出报告说明
**表2 输出报告说明**
<table>
  <tr>
    <th>参数</th>
    <th>说明</th>
  </tr>
  <tr>
    <td>配置信息</td>
    <td>显示软件源码文件存放路径，目标操作系统和目标系统内核版本以及评估结果。</td>
  </tr>
  <tr>
    <td>需要修改的源码文件</td>
    <td>显示需要进行修改的源码文件路径等相关信息。</td>
  </tr>
</table>

## 5.3 字节对齐检查

### 5.3.1 命令参数说明
字节对齐检查就是在需要考虑字节对齐时，检查源码中结构体类型变量的字节对齐情况。
#### 命令功能
查看所有结构体字节对齐检查命令参数。

#### 命令格式
```shell
devkit advisor addr-align -h
```

#### 使用实例
执行以下命令，查看所有命令参数说明。
```shell
devkit advisor addr-align -h
```
返回信息如下：
```shell
    OVERVIEW
        Run this command to check the byte alignment of structure variables in the source code.

    USAGE
        devkit advisor addr-align 
        [-h | --help] 
        {-i INPUT_PATH | --input INPUT_PATH} 
        {-c COMMAND | --command COMMAND}
        [-o OUTPUT_PATH | --output OUTPUT_PATH] 
        [-r {all,json,html,csv} | --report-type {all,json,html,csv}]
        [-l {0,1,2,3} | --log-level {0,1,2,3}] 
        [--set-timeout TIMEOUT]

    OPTIONS
        -h, --help
        Get help information and exit.
        
        -i, --input INPUT_PATH
        [Mandatory option] Specifies the path of the source code folder to be scanned.
        
       -c, --cmd COMMAND
        [Mandatory option] Specifies the build command of the source code. Use " or ' to include commands. Use semicolons ; to separate multiple commands. Commands for setting environment variables or common variables are not supported.
        
        -o, --output OUTPUT_PATH
        Specify the path for storing the scan report and the file name.
        By default, the file is stored in the current path(pwd) and its name is in the format of function name_timestamp.
        
        -l, --log-level {0,1,2,3}
        Specifies the log level of the current task, 0(DEBUG) | 1(INFO) | 2(WARNING) | 3(ERROR). The default value is 1(INFO).
        
        -r, --report-type {all,json,html,csv}
        Specify the report type for the scan report. The default value is all.
        
        --set-timeout <min>
        Specifies the timeout period of a task. By default, the timeout period is not set.

    EXAMPLE
        # Scan a project and generate scanning reports.
        devkit advisor addr-align -i /home/advisor/project -c 'make'
```

### 5.3.2 使用命令行进行字节对齐检查

#### 命令功能
检查源码中结构体变量的字节对齐情况。

#### 命令格式
```shell
devkit advisor addr-align [-h | --help] {-i INPUT_PATH | --input INPUT_PATH} {-c COMMAND | --cmd COMMAND} [-o OUTPUT_PATH | --output OUTPUT_PATH] [-r {all,json,html,csv} | --report-type {all,json,html,csv}] [-l {0,1,2,3} | --log-level  {0,1,2,3}] [--set-timeout TIMEOUT]
```

#### 参数说明
**表1 参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>-</td>
    <td>
      获取帮助信息。
    </td>
  </tr>
  <tr>
  <tr>
    <td>-i/--input</td>
    <td>input_path</td>
    <td>
      必选参数，待扫描的源码文件夹路径。
    </td>
  </tr>
  <tr>
    <td>-c/--cmd</td>
    <td>cmd</td>
    <td>
      必选参数，源码构建命令。<br>      
      在服务器中正常执行的构建命令，若存在多个构建命令需使用英文分号分割并用英文双引号包住。命令中如有空格，也需要用英文双引号包住。<br>
      例如："mkdir build;cd build;cmake ..;make"。
    </td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>output_path</td>
    <td>
      扫描报告的存放路径，默认存放在当前执行路径下，名称默认为“模块名称_时间戳”。
    </td>
  </tr>
  <tr>
    <td>--set-timeout</td>
    <td>time</td>
    <td>
      任务超时时间，单位为分钟，若执行时间超过超时时间则退出执行。默认无超时时间，任务将持续执行直到结束。
    </td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      设置日志级别，默认为1。<br>
      0：日志级别为DEBUG。<br>
      1：日志级别为INFO。<br>
      2：日志级别为WARNING。<br>
      3：日志级别为ERROR。
    </td>
  </tr>
  <tr>
    <td>-r/--report-type</td>
    <td>all,json,html,csv</td>
    <td>
      扫描报告的格式，默认为all。<br>
      all：生成JSON、HTML、CSV三种格式报告。<br>
      json：生成JSON格式报告。<br>
      html：生成HTML格式报告。<br>
      csv：生成CSV格式报告。
    </td>
  </tr>
</table>

#### 使用实例
此处以扫描“/opt/DevKit/wtdbg2-2.5”文件夹下源码，构建命令为make且日志级别为DEBUG为例，请根据实际情况进行修改。
```shell
devkit advisor addr-align -i /opt/DevKit/wtdbg2-2.5 -c make -l 0
```
返回信息如下，并输出报告。
```shell
Scanned time: 2024/02/29 02:44:48
Configuration:
    Scan source code path: /opt/DevKit/wtdbg2-2.5
    Generate report path: /opt/DevKit/workspace/devadmin/porting/package
    Generate report type: all
    Task Timeout Interval: The timeout period is not set.
    Log level: debug

For the detailed information, please check
    /opt/DevKit/workspace/devadmin/porting/package/addr-align_20240229024448_4d53.html
    /opt/DevKit/workspace/devadmin/porting/package/addr-align_20240229024448_4d53.json
    /opt/DevKit/workspace/devadmin/porting/package/addr-align_20240229024448_4d53.csv
```

#### 输出报告说明
**表2 输出报告说明**
<table>
  <tr>
    <th>参数</th>
    <th>说明</th>
  </tr>
  <tr>
    <td>配置信息</td>
    <td>显示软件源码文件存放路径，目标操作系统和目标系统内核版本以及评估结果。</td>
  </tr>
  <tr>
    <td>需要修改的源码文件</td>
    <td>显示需要进行字节对齐的源码文件路径等相关信息。</td>
  </tr>
</table>

## 5.4 bc文件生成

### 5.4.1 命令参数说明
bc文件生成功能用于对指定源码生成bc文件，用于内存一致性检查和向量化检查。

#### 命令功能
查看bc文件生成的所有命令参数。

#### 命令格式
```shell
devkit advisor bc-gen -h
```

#### 使用实例
执行以下命令，查看所有命令参数说明。
```shell
devkit advisor bc-gen -h
```
返回信息如下：
```shell
  OVERVIEW
      Run this command to compile the source code using LLVM and generate BC files.

  USAGE
      devkit advisor bc-gen 
      [-h | --help]
      {-c COMMAND | --command COMMAND}
      [-o OUTPUT_PATH | --output OUTPUT_PATH]
      [-l {0,1,2,3} | --log-level {0,1,2,3}]
      [--set-timeout TIMEOUT]
      [-t THREADS | --thread THREADS]

  OPTIONS
      -h, --help
      Get help information and exit.

      -c, --command COMMAND
      [Mandatory option] Specifies the build command of the source code. Use " or ' to include commands. Use semicolons ; to separate multiple commands. Commands for setting environment variables or common variables are not supported.

      -o, --output OUTPUT_PATH
      Specifies the path for storing the folder of BC files. By default, the folder is stored in the current path(pwd) and its name is in the format of function name_timestamp.

      -l, --log-level {0,1,2,3}
      Specifies the log level of the current task, 0(DEBUG) | 1(INFO) | 2(WARNING) | 3(ERROR). The default value is 1(INFO).

      --set-timeout <min>
      Specifies the timeout period of a task. By default, the timeout period is not set.

      -t, --thread THREADS
      Specifies the thread to generate bc files. Use the provided number of threads as much as possible. By default, the threads is cpu_num / 2.

  EXAMPLE
      Compile a project and generate BC files.
      1、Prepare build files. (Run the command such as configure and cmake).
      2、Run bc-gen in the project directory to compile the project and generate BC files:
        devkit advisor bc-gen -c 'make'
```

### 5.4.2 使用命令行进行bc文件生成

#### 命令功能
对可代码生成bc文件。

#### 命令格式
```shell 
devkit advisor bc-gen [-h | --help] {-c COMMAND | -- command COMMAND} [-o OUTPUT_PATH | --output OUTPUT_PATH] [-l {0,1,2,3} | --log-level {0,1,2,3}] [--set-timeout TIMEOUT] [-t THREADS | --thread THREADS]
```

#### 参数说明
**表1 参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>-</td>
    <td>
      获取帮助信息。
    </td>
  </tr>
  <tr>
    <td>-c/--command</td>
    <td>command</td>
    <td>
      必选参数，源码的构建命令。<br>
      例如：make all。
    </td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>output_path</td>
    <td>
      生成BC文件的存放路径，需要有写权限。报告默认存放在当前路径下，名称默认为“模块名_时间戳”。
    </td>
  </tr>
  <tr>
    <td>--set-timeout</td>
    <td>time</td>
    <td>
      任务超时时间，单位为分钟，若执行时间超过超时时间则退出执行。默认无超时时间，任务将持续执行直到结束。
    </td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      设置日志级别，默认为1。<br>
      0：日志级别为DEBUG。<br>
      1：日志级别为INFO。<br>
      2：日志级别为WARNING。<br>
      3：日志级别为ERROR。
    </td>
  </tr>
  <tr>
    <td>-t/--thread</td>
    <td>thread_num</td>
    <td>
      编译bc文件时的线程数，默认为当前环境CPU总数的一半。
    </td>
  </tr>
</table>

#### 使用实例
执行以下命令，生成BC文件。此处以扫描“/home/test”下源码文件，编译命令为cmake .、make，BC文件保存在“/home/test/bc_files”下为例，请根据实际情况进行修改。
```shell
cd /home/test && cmake .
devkit advisor bc-gen -c make -o /home/test/bc_files
```
返回信息如下，并输出bc文件文件夹路径。
```shell
Executing bc gen task, please wait...
Current progress: ###### [20%]
Start to get the compile database
Current progress: ################ [50%]
Start to generate the bc files
Current progress: ################################# [100%]
Configuration:
    Generate bc files path: /home/test/bc_files
    Compile command: make
    Threads: The threads is not set, using the half number of cores.
    Task Timeout Interval: The timeout period is not set.
    Log level: info

Summary:
    Scanned all source files, there are 5 linked bc files and 5 object bc files generated.

For the detail information, please check:
Output path of linked bc files: /home/test/bc_files/bc-gen_20250408112730_d397/bin
Output path of object bc files: /home/test/bc_files/bc-gen_20250408112730_d397/object

There are 3 linked bc files fail to be generated. For the causes of the failure to generate all the bc files and their intermediates, please check:
Log path: /install_path/advisor/logs/affinity/affinity.log
Warning and error messages when generate all the bc files: /current_path/bc_warning.json
```

## 5.5 内存一致性检查

### 5.5.1 命令参数说明
内存一致性检查就是检查源码迁移在鲲鹏平台运行时可能存在的内存一致性问题，并提供插入内存屏障的建议。

#### 命令功能
查看内存一致性检查所有命令参数。

#### 命令格式
```shell
devkit advisor mm-check -h
```

#### 使用实例
执行以下命令，查看所有命令参数说明。
```shell
devkit advisor mm-check -h
```
返回信息如下：
```shell
    OVERVIEW
        Run this command to check for any memory consistency problem when the source code is ported to the Kunpeng platform and provides suggestions on inserting memory barriers.

    USAGE
        devkit advisor mm-check 
        [-h | --help] 
        {-i INPUT_PATH | --input INPUT_PATH} 
        {-f BC_PATH | --bc-file BC_PATH} 
        [--autofix {true,false}] 
        [--autofix-dir AUTOFIX_OUTPUT_PATH] 
        [-o OUTPUT_PATH | --output OUTPUT_PATH] 
        [-r {all,json,html,csv} | --report-type {all,json,html,csv}] 
        [-l {0,1,2,3} | --log-level {0,1,2,3}] 
        [--set-timeout TIMEOUT]

    OPTIONS
        -h, --help
        Get help information and exit.

        -i, --input INPUT_PATH
        [Mandatory option] Specifies the folder path of the source code to be scanned.
        
        -f, --bc-file BC_PATH
        [Mandatory option] Specifies the folder path of the bc file to be scanned. For the detail, please refer to the following document:
        'https://www.hikunpeng.com/document/detail/zh/kunpengdevps/userguide/Plugins_UserGuide/DevKit_Affinity_0018.html'.
        
        --autofix {true,false}
        Specifies whether to generate the compiler configuration file.
        
        --autofix-dir   AUTOFIX_OUTPUT_PATH
        Specify the path for storing the compile configuration file. By default, the file is stored in the current path(pwd) and its name is in the format of function autofixlist_timestamp.
        
        -o, --output OUTPUT_PATH
        Specify the path for storing the scan report and the file name. By default, the file is stored in the current path(pwd) and its name is in the format of function name_timestamp.
        
        -l, --log-level {0,1,2,3}
        Specifies the log level of the current task, 0(DEBUG) | 1(INFO) | 2(WARNING) | 3(ERROR). The default value is 1(INFO).
        
        -r, --report-type {all,json,html,csv}
        Specify the report type for the scan report. The default value is all.
        
        --set-timeout <min>
        Specifies the timeout period of a task. By default, the timeout period is not set.

    EXAMPLE
        # Scan a project and generate scanning reports.
        devkit advisor mm-check -i /home/advisor/project -f /home/advisor/source.bc
```

### 5.5.2 使用命令行进行内存一致性检查

#### 命令功能
检查源码中存在的内存一致性问题。

#### 命令格式
```shell
devkit advisor mm-check [-h | --help] {-i INPUT_PATH | --input  INPUT_PATH} [-f BC_PATH | --bc-file BC_PATH] [--autofix {true,false}] [--autofix-dir AUTOFIX_OUTPUT_PATH] [-o OUTPUT_PATH | --output OUTPUT_PATH]  [-r {all,json,html,csv} | --report-type {all,json,html,csv}] [-l  {0,1,2,3} | --log-level {0,1,2,3}] [--set-timeout TIMEOUT]
```

#### 参数说明
**表1 参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>-</td>
    <td>
      获取帮助信息。
    </td>
  </tr>
  <tr>
    <td>-i/--input</td>
    <td>input_path</td>
    <td>
      必选参数,BC文件对应的源码文件路径。
    </td>
  </tr>
  <tr>
    <td>-f/--bc-file</td>
    <td>path</td>
    <td>
      必选参数,BC文件路径，该路径下必须存在BC文件。
    </td>
  </tr>
  <tr>
    <td>--autofix</td>
    <td>true/false</td>
    <td>
      是否生成编译器配置文件，默认为false。
    </td>
  </tr>
  <tr>
    <td>--autofix-dir</td>
    <td>path</td>
    <td>
      编译器配置文件的存放地址。默认生成在工具目录下的源码文件夹下，使用--autofix且参数必须为true时才能生效。
    </td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>output_path</td>
    <td>
      扫描报告的存放路径，默认存放在当前执行路径下，报告名称为“模块名称_时间戳”。
    </td>
  </tr>
  <tr>
    <td>--set-timeout</td>
    <td>time</td>
    <td>
      任务超时时间，单位为分钟，若执行时间超过超时时间则退出执行。默认无超时时间，任务将持续执行直到结束。
    </td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      设置日志级别，默认为1。<br>
      0：日志级别为DEBUG。<br>
      1：日志级别为INFO。<br>
      2：日志级别为WARNING。<br>
      3：日志级别为ERROR。
    </td>
  </tr>
  <tr>
    <td>-r/--report-type</td>
    <td>all,json,html,csv</td>
    <td>
      扫描报告的格式，默认为all。<br>
      all：生成JSON、HTML、CSV三种格式报告。<br>
      json：生成JSON格式报告。<br>
      html：生成HTML格式报告。<br>
      csv：生成CSV格式报告。
    </td>
  </tr>
</table>

#### 使用实例
此处以扫描“/opt/DevKit/testcase/affinity/weak_cons/test-mulbc_sort”路径下源码为例，请根据实际情况进行修改。
```shell
devkit advisor mm-check -i /opt/DevKit/testcase/affinity/weak_cons/test-mulbc_sort -f /opt/DevKit/testcase/affinity/weak_cons/bc_file -l 0
```
返回信息如下，并输出报告。
```shell
Scanned time: 20240229061648
Configuration:
    Scan bc files path: /opt/DevKit/testcase/affinity/weak_cons/bc_file
    Scan source code path: /opt/DevKit/testcase/affinity/weak_cons/test-mulbc_sort
    Autofix: false
    Generate report path: /home/DevKit_Software
    Generate report type: all
    Task Timeout Interval: The timeout period is not set.
    Log level: debug

Summary:
    Scanned 2 bc files, there are 6 recommended modifications.

For the details information, please check:
    /home/DevKit_Software/mem-check_20240229061648_7905.json
    /home/DevKit_Software/mem-check_20240229061648_7905.html
    /home/DevKit_Software/mem-check_20240229061648_7905.csv
```

#### 输出报告说明
**表2 输出报告说明**
<table>
  <tr>
    <th>参数</th>
    <th>说明</th>
  </tr>
  <tr>
    <td>配置信息</td>
    <td>显示软件源码文件存放路径，目标操作系统和目标系统内核版本以及评估结果。</td>
  </tr>
  <tr>
    <td>需要修改的源码文件</td>
    <td>显示需要存在内存一致性问题需要进行修改的源码文件路径等相关信息。</td>
  </tr>
</table>

## 5.6 向量化检查

### 5.6.1 命令参数说明
向量化检查功能用于对可向量化片段进行检查，并提供向量化修改建议。

#### 命令功能
查看向量化检查所有命令参数。

#### 命令格式
```shell
devkit advisor vec-check -h
```

#### 使用实例
执行以下命令，查看所有命令参数说明。
```shell
devkit advisor vec-check -h
```
返回信息如下：
```shell
    OVERVIEW
        Run this command to check vectorizable code fragments and provide modification suggestions.

    USAGE
        devkit advisor vec-check 
        [-h | --help] 
        {-i INPUT_PATH | --input INPUT_PATH} 
        {-f BC_PATH| --bc-file BC_PATH} 
        {-c COMMAND | --cmd COMMAND}
        [-p {clang,gcc} | --compiler {clang,gcc}]
        [-o OUTPUT_PATH | --output OUTPUT_PATH] 
        [-r {all,json,html,csv} | --report-type {all,json,html,csv}] 
        [-l {0,1,2,3} | --log-level {0,1,2,3}] 
        [--set-timeout TIMEOUT] 
        [--sve-enable {true,false}]

    OPTIONS
        -h, --help
        Get help information and exit.
        
        -i, --input INPUT_PATH
        [Mandatory option] Specifies the folder path of the source code to be scanned.
        
        -f, --bc-file BC_PATH
        [Mandatory option] Specifies the folder path of the bc file to be scanned. For the detail, please refer to the following document:
        'https://www.hikunpeng.com/document/detail/zh/kunpengdevps/userguide/Plugins_UserGuide/DevKit_Affinity_0018.html'.
        
        -c, --cmd COMMAND
        [Mandatory option] Specifies the build command of the source code. Use " or ' to include commands. Use semicolons ; to separate multiple commands. Commands for setting environment variables or common variables are not supported.
        
        -o, --output OUTPUT_PATH
        Specify the path for storing the scan report and the file name. By default, the file is stored in the current path(pwd) and its name is in the format of function name_timestamp.
        
        -p, --compiler {clang,gcc}
        Specifies the compiler used for compiling source code. The default value is clang.
        
        -l, --log-level {0,1,2,3}
        Specifies the log level of the current task, 0(DEBUG) | 1(INFO) | 2(WARNING) | 3(ERROR). The default value is 1(INFO).
        
        -r, --report-type {all,json,html,csv}
        Specify the report type for the scan report. The default value is all.
        
        --set-timeout <min>
        Specifies the timeout period of a task. By default, the timeout period is not set.
        
        --sve-enable
            Enable SVE. SVE is a variable-length vectorized instruction introduced after ARMv8a to enhance binary code portability so that it can run on a wider SIMD unit.

    EXAMPLE
        # Scan a project and generate scanning reports.
        devkit advisor vec-check -i /home/porting/cplusproject -f /home/advisor/source.bc -c 'make' -p gcc7
```

### 5.6.2 使用命令行进行向量化检查

#### 命令功能
对可向量化片段进行检查。
```text
[说明]
使用向量化需要在运行环境上准备对应编译器版本。
- GCC版本：GCC 7/GCC 8/GCC 9/GCC 10
- clang版本：clang12/clang15
```

#### 命令格式
```shell
devkit advisor vec-check [-h | --help] {-i INPUT_PATH | --input  INPUT_PATH} {-f BC_PATH| --bc-file BC_PATH} {-c COMMAND | --cmd COMMAND} [-p  {clang,gcc} | --compiler {clang,gcc}][-o OUTPUT_PATH | --output OUTPUT_PATH] [-r {all,json,html,csv} | --report-type {all,json,html,csv}] [-l  {0,1,2,3} | --log-level {0,1,2,3}] [--set-timeout  TIMEOUT] [--sve-enable {true,false}]
```

#### 参数说明
**表1 参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>-</td>
    <td>
      获取帮助信息。
    </td>
  </tr>
  <tr>
    <td>-i/--input</td>
    <td>input_path</td>
    <td>
      必选参数，BC文件对应的源码文件夹路径。
    </td>
  </tr>
  <tr>
    <td>-f/--bc-file</td>
    <td>path</td>
    <td>
      必选参数，BC文件夹路径，该路径下必须存在BC文件。
    </td>
  </tr>
    <tr>
    <td>-c/--cmd</td>
    <td>cmd</td>
    <td>
      必选参数，源码的构建命令。
    </td>
  </tr>
  <tr>
    <td>-p/--compiler</td>
    <td>gcc,clang</td>
    <td>
      指定用于编译源码的编译器，默认为clang。
    </td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>output_path</td>
    <td>
      扫描报告的存放路径，默认存放在当前执行路径下，报告名称为“模块名称_时间戳”。
    </td>
  </tr>
  <tr>
    <td>--set-timeout</td>
    <td>time</td>
    <td>
      任务超时时间，单位为分钟，若执行时间超过超时时间则退出执行。默认无超时时间，任务将持续执行直到结束。
    </td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      设置日志级别，默认为1。<br>
      0：日志级别为DEBUG。<br>
      1：日志级别为INFO。<br>
      2：日志级别为WARNING。<br>
      3：日志级别为ERROR。
    </td>
  </tr>
  <tr>
    <td>-r/--report-type</td>
    <td>all,json,html,csv</td>
    <td>
      扫描报告的格式，默认为all。<br>
      all：生成JSON、HTML、CSV三种格式报告。<br>
      json：生成JSON格式报告。<br>
      html：生成HTML格式报告。<br>
      csv：生成CSV格式报告。
    </td>
  </tr>
  <tr>
    <td>--sve-enable</td>
    <td>true,false</td>
    <td>
      是否启用sve，默认不开启。SVE是在ARMv8a之后引入的可变长度向量化指令，目的是增强二进制代码的可移植性，使其可以运行在更广泛的SIMD单元上。
    </td>
  </tr>
</table>

#### 使用实例
此处以扫描“/home/testcase/cplusproject”路径下源码文件为例，请根据实际情况进行修改。
```shell
devkit advisor vec-check -i /home/testcase/cplusproject -f /home/advisor/bc_file -c 'make' -p gcc -l 0
```
返回信息如下，并输出报告。
```shell
Scanned time: 2024/02/29 06:11:25
Configuration:
    Scan bc files path: /home/advisor/bc_file
    Scan source code path: /home/testcase/cplusproject
    Command: make
    Compiler: gcc
    EnableSVE: false
    Generate report path: /home/DevKit_Softwar
    Generate report type: all
    Task Timeout Interval: The timeout period is not set.
    Log level: debug

Summary:
    Scanned 1 bc files, there are 0 recommended modifications.

For the detailed information, please check
   /home/DevKit_Software/vec-check_20240229061125_0cdc.json
   /home/DevKit_Software/vec-check_20240229061125_0cdc.html
   /home/DevKit_Software/vec-check_20240229061125_0cdc.csv
```

#### 输出报告说明
**表2 输出报告说明**
<table>
  <tr>
    <th>参数</th>
    <th>说明</th>
  </tr>
  <tr>
    <td>配置信息</td>
    <td>显示软件源码文件存放路径，目标操作系统和目标系统内核版本以及评估结果。</td>
  </tr>
  <tr>
    <td>需要修改的源码文件</td>
    <td>显示存在向量化问题，并需要进行修改的源码文件路径等相关信息。</td>
  </tr>
</table>


## 5.7 矩阵化检查

### 5.7.1 命令参数说明
矩阵化检查功能用于对可矩阵化片段进行检查，并提供矩阵化修改建议。

#### 命令功能
查看矩阵化检查所有命令参数。

#### 命令格式
```shell
devkit advisor matrix-check -h
```

#### 使用实例
执行以下命令，查看所有命令参数说明。
```shell
devkit advisor matrix-check -h
```
返回信息如下：
```shell
  OVERVIEW
      Run this command to check the matrixed segments and suggest matrixing
      changes.

  USAGE
      devkit advisor matrix-check
      [-h | --help]
      {-i INPUT_PATH | --input INPUT_PATH}
      [-s SCAN_DIR | --scan-dir SCAN_DIR]
      [-b {make, cmake} | --build-tool {make,cmake}]
      [-c COMMAND | --cmd COMMAND]
      [-j COMPILE_JSON_PATH | --compile-command-json COMPILE_JSON_PATH]
      [-o OUTPUT_PATH | --output OUTPUT_PATH]
      [-r {all,html,csv} | --report-type {all,html,csv}]
      {-p {sme,domain} | --optimization {sme,domain}}
      [-m {compute,memory_access,communication} | --module {compute,memory_access,communication}]
      [-l {0,1,2,3} | --log-level {0,1,2,3}]
      [--set-timeout TIMEOUT]

  OPTIONS
      -h, --help
      Get help information and exit.
      
      -i, --input INPUT_PATH
      [Mandatory option] Specifies the path of the source code folder to be scanned.
      
      -s, --scan-dir SCAN_DIR
      Specifies the relative path of the file or folder to be scanned in the input_path directory. Separate multiple files or folders with spaces.

      -b, --build-tool {make,cmake}
      Specifies the building tool. The default value is make.

      -c, --cmd COMMAND
      Specifies the build command of the source code. Use " or ' to include commands. The default value is make.

      -j, --compile-command-json
      The absolute path of compile_command.json. For the detail, please referto the following document:
      'https://www.hikunpeng.com/document/detail/zh/kunpengdevps/userguide/Plugins_UserGuide/DevKit_Affinity_0020.html'
      When the compile command json(-j/--compile-command-json) is specified, the build tool(-b/--build-tool) or command(-c/--cmd) cannot be specified at the same time.

      -o, --output OUTPUT_PATH
      Specifies the path for storing the scan report and the file name.By default, the file is stored in the current path(pwd) and its name is in the format of function name_timestamp.

      -r, --report-type {all,html,csv}
      Specifies the report type for the scan report. The default value is all.

      -p, --optimization {sme,domain}
      [Mandatory option] Specifies the matrix optimization method.

      -m, --module {compute,memory_access,communication}
      Specifies domain optimization method.

      -l, --log-level {0,1,2,3}
      Specifies the log level of the current task, 0(DEBUG) | 1(INFO) | 2(WARNING) | 3(ERROR). The default value is 1(INFO).

      --set-timeout <min>
      Specifies the timeout period of a task. By default, the timeout period is not set.

  EXAMPLE
      # Scan a project and generate scanning reports.
      devkit advisor matrix-check -i /home/advisor/project -b make -c 'make' -p sme
      devkit advisor matrix-check -i /home/advisor/project -b make -c 'make' -p sme -s lib/fft/
      devkit advisor matrix-check -i /home/advisor/project -b make -c 'make' -p domain -m compute,memory_access,communication
      devkit advisor matrix-check -i /home/advisor/project -b make -c 'make' -p sme,domain -m compute,memory_access,communication
```

### 5.7.2 使用命令行进行矩阵化检查

#### 命令功能
对可矩阵化片段进行检查。
```text
[说明]
使用矩阵化需要在运行环境上准备对应编译器版本。
- GCC版本：GCC 7/GCC 8/GCC 9/GCC 10
- clang版本：clang12/clang15
```

#### 命令格式
```shell 
devkit advisor matrix-check [-h | --help] {-i INPUT_PATH | --input INPUT_PATH} [-s scan_file_path | --scan-dir scan_file_path] [-b {make,cmake} | --build-tool {make,cmake}]  [-c COMMAND | --cmd COMMAND] [-j COMPILE_JSON_PATH | --compile-command-json COMPILE_JSON_PATH] [-o OUTPUT_PATH | --output OUTPUT_PATH] [-r {all,html,csv} | --report-type {all,html,csv}] {-p {sme,domain} | --optimization {sme,domain}} [-m {compute,memory_access,communication} | --module {compute,memory_access,communication}] [-l {0,1,2,3} | --log-level {0,1,2,3}] [--set-timeout TIMEOUT]
```

#### 参数说明
**表1 参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>-</td>
    <td>
      获取帮助信息。
    </td>
  </tr>
  <tr>
  <tr>
    <td>-i/--input</td>
    <td>input_path</td>
    <td>
      必选参数，待扫描的源码文件夹路径。
    </td>
  </tr>
  <tr>
    <td>-s/--scan-dir</td>
    <td>scan_directory</td>
    <td>
      待扫描的源码文件夹或包路径，支持多路径，多路径之间用空格分割。
    </td>
  </tr>
  <tr>
    <td>-b/--build-tool</td>
    <td>make,cmake</td>
    <td>
      构建工具，默认为make。
    </td>
  </tr>
    <tr>
    <td>-c/--cmd</td>
    <td>command</td>
    <td>
      源码的构建命令。若命令包含空格，需使用单引号。<br>
      -c和-j二者必填一项。
    </td>
  </tr>
  <tr>
    <td>-j/--compile-command-json</td>
    <td>compile_command_json_path</td>
    <td>
      指定compile_commands.json文件的所在路径。<br>
      -c和-j二者必填一项。
    </td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>output_path</td>
    <td>
      扫描报告的存放路径，默认存放在当前执行路径下，报告名称为“模块名称_时间戳”。
    </td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      设置日志级别，默认为1。<br>
      0：日志级别为DEBUG。<br>
      1：日志级别为INFO。<br>
      2：日志级别为WARNING。<br>
      3：日志级别为ERROR。
    </td>
  </tr>
  <tr>
    <td>-r/--report-type</td>
    <td>all,html,csv</td>
    <td>
      扫描报告的格式，默认为all。<br>
      all：生成HTML、CSV两种格式报告。<br>
      html：生成HTML格式报告。<br>
      csv：生成CSV格式报告。
    </td>
  </tr>
  <tr>
    <td>-p/--optimization</td>
    <td>sme,domain</td>
    <td>
      必选参数，指定矩阵化优化方法，。<br>
      sme：SME矩阵化，包括Stencil、GEMV和FFT。<br>
      domain：领域优化，必须与-m选项同时使用。
    </td>
  </tr>
    <tr>
    <td>-m/--module</td>
    <td>compute,memory_access,communication</td>
    <td>
      可选参数，指定领域优化方法。<br>
      compute：计算优化，包括数学恒等变换、消除冗余公共算子、单位阶跃计算优化、精度一致除转乘、查找算法领域优化、归约计算并行化、制导语句优化、sin/cos算子融合、exp计算化简和循环合并。<br>
      memory_access：仿存优化，即超大数据降维优化。<br>
      communication：通讯优化，即通信隐藏优化。<br>
      当矩阵化优化选择domain时，领域优化方法至少选一项
    </td>
  </tr>
  <tr>
    <td>--set-timeout</td>
    <td>time</td>
    <td>
      任务超时时间，单位为分钟，若执行时间超过超时时间则退出执行。默认无超时时间，任务将持续执行直到结束。
    </td>
  </tr>
</table>

#### 使用实例
此处以扫描“/home/test_code/data”路径下源码，且构建工具为make，构建命令为make，矩阵化优化方式为SME矩阵化和领域优化为例，请根据实际情况进行修改。
```shell
devkit advisor matrix-check -i /home/test_code/data -c make -b make -o /home/out/ -p domain,sme -m compute,memory_access,communication
```
返回信息如下，并输出报告。
```shell
Executing matricization check task, please wait...
Current progress: ################################# [100%]
Scanned time: 2024/06/12 02:18:35

Configuration: 
    Scan source code path: /home/test_code/data
    Generate report path: /home/out
    Generate report type: all
    Task Timeout Interval: The timeout period is not set.
    Log level: info

Summary:
    Scanned 11 files, there are 50 sugguestions.

For the details information, please check:
    /home/out/matrix-check_20240612021835_2d68.html
    /home/out/matrix-check_20240612021835_2d68.csv
After the project analysis is complete, additional optimization files are generated in /home/out/matrix-check_20240612021835_2d68
Download the optimization files and adapt the project build files.
Adapt the project build files to the FFT-SME library, which is located in /home/out/fftm.zip
```

#### 输出报告说明
**表2 输出报告说明**
<table>
  <tr>
    <th>参数</th>
    <th>说明</th>
  </tr>
  <tr>
    <td>配置信息</td>
    <td>显示软件源码文件存放路径以及评估结果。</td>
  </tr>
  <tr>
    <td>需要修改的源码文件</td>
    <td>显示存在矩阵化问题，并需要进行修改的源码文件路径等相关信息。</td>
  </tr>
</table>

## 5.8 构建亲和检查

### 5.8.1 命令参数说明
构建亲和功能用于分析构建过程中可以替换鲲鹏加速库的内容，并提供替换建议和功能修复。
#### 命令功能
查看构建亲和检查所有命令参数。

#### 命令格式
```shell
devkit advisor affi-check -h
```

#### 使用实例
执行以下命令，查看所有命令参数说明。
```shell
devkit advisor affi-check -h
```
返回信息如下：
```shell
OVERVIEW
    Run this command to analyze the content in Makefile and CMakeLists.txt that can be replaced with content in the Kunpeng library, and provides replacement suggestions and function repair.

USAGE
    devkit advisor affi-check
    [-h | --help]
    {-i INPUT_PATH | --input INPUT_PATH}
    {-c COMMAND | --cmd COMMAND}
    [-o OUTPUT_PATH | --output OUTPUT_PATH]
    [-r {all,json,html,csv} | --report-type {all,json,html,csv}]
    [-l {0,1,2,3} | --log-level {0,1,2,3}]
    [--set-timeout TIMEOUT]

OPTIONS
    -h, --help
    Get help information and exit.

    -i, --input INPUT_PATH
    [Mandatory option] Specifies the folder or package path of the source code to be scanned.

    -c, --cmd COMMAND
    [Mandatory option] Specifies the build command of the source code. Use " or ' to include commands. Use semicolons ; to separate multiple commands. Commands for setting environment variables or common variables are not supported.

    -o, --output OUTPUT_PATH
    Specifies the path for storing the scan report and the file name. By default, the file is stored in the current path(pwd) and its name is in the format of function name_timestamp.

    -l, --log-level {0,1,2,3}
    Specifies the log level of the current task, 0(DEBUG) | 1(INFO) | 2(WARNING) | 3(ERROR). The default value is 1(INFO).

    -r, --report-type {all,json,html,csv}
    Specifies the report type for the scan report. The default value is all.

    --set-timeout <min>
    Specifies the timeout period of a task. By default, the timeout period is not set.

EXAMPLE
    # Scan a project and generate scanning reports.
    devkit advisor affi-check -i /home/advisor/project -b make -c 'make'
```

### 5.8.2 使用命令行进行构建亲和检查

#### 命令功能
使用命令通过终端工具进行运行模式检查。

#### 命令格式
```shell
devkit advisor affi-check [-h | --help] {-i INPUT_PATH | --input INPUT_PATH} {-c COMMAND | --cmd COMMAND} [-o OUTPUT_PATH | --output OUTPUT_PATH] [-r {all,json,html,csv} | --report-type {all,json,html,csv}] [-l {0,1,2,3} | --log-level {0,1,2,3}] [--set-timeout TIMEOUT]
```

#### 参数说明
**表1 参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>-</td>
    <td>
      获取帮助信息。
    </td>
  </tr>
  <tr>
    <td>-i/--input</td>
    <td>input_path</td>
    <td>
      必选参数，对应的源码文件夹路径。
    </td>
  </tr>
  <tr>
    <td>-c/--cmd</td>
    <td>command</td>
    <td>
      必选参数，源码的构建命令。
    </td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>output_path</td>
    <td>
      扫描报告的存放路径，默认存放在当前执行路径下，报告名称为“模块名称_时间戳”。
    </td>
  </tr>
  <tr>
    <td>--set-timeout</td>
    <td>time</td>
    <td>
      任务超时时间，单位为分钟，若执行时间超过超时时间则退出执行。默认无超时时间，任务将持续执行直到结束。
    </td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      设置日志级别，默认为1。<br>
      0：日志级别为DEBUG。<br>
      1：日志级别为INFO。<br>
      2：日志级别为WARNING。<br>
      3：日志级别为ERROR。
    </td>
  </tr>
  <tr>
    <td>-r/--report-type</td>
    <td>all,json,html,csv</td>
    <td>
      扫描报告的格式，默认为all。<br>
      all：生成JSON、HTML、CSV三种格式报告。<br>
      json：生成JSON格式报告。<br>
      html：生成HTML格式报告。<br>
      csv：生成CSV格式报告。
    </td>
  </tr>
</table>

#### 使用实例
此处以扫描“/home/advisor/project”路径下源码，构建命令为make为例，请根据实际情况进行修改。
```shell
devkit advisor affi-check -i /home/advisor/project -o /home/output -c make
```
返回信息如下，并输出报告。
```shell
Executing Build Affinity Analysis task, please wait...
Data initialization.
Current progress: ### [10%]
Compiling the project. It may take a long time. Please wait...
Current progress: #################### [60%]
Optimization suggestions for the matching acceleration library.
Current progress: ################################# [100%]
Build Affinity Analysis task has been executed.
Scanned time: 2024/08/26 06:47:52
Scan status: Succeed. Some items are recommended to be modified.

Configuration:
     Source code file path: /home/advisor/project
     Log level: info
     Report type: all
     Timeout interval setting: The timeout period is not set.

Summary:
      2 dependency files can be accelerated.

For the detailed information, please check:
/home/output/affi-check_20240826064752_b85e.json
/home/output/affi-check_20240826064752_b85e.html
/home/output/affi-check_20240826064752_b85e.csv
```

#### 输出报告说明
**表2 输出报告说明**
<table>
  <tr>
    <th>参数</th>
    <th>说明</th>
  </tr>
  <tr>
    <td>配置信息</td>
    <td>显示软件源码文件存放路径，目标操作系统和目标系统内核版本以及评估结果。</td>
  </tr>
  <tr>
    <td>可以加速的依赖文件数</td>
    <td>显示可以进行加速的依赖文件路径等相关信息。</td>
  </tr>
</table>

## 5.9 缓存行对齐检查

### 5.9.1 命令参数说明
缓存行对齐检查功能用于对C/C++源码中结构体变量进行128字节对齐检查，给出修改建议。

#### 命令功能
查看缓存行对齐检查的所有命令参数。

#### 命令格式
```shell
devkit advisor cacheline -h
```

#### 使用实例
执行以下命令，查看所有命令参数说明。
```shell
devkit advisor cacheline -h
```
返回信息如下：
```shell
  OVERVIEW
      Run this command to check the 128-byte alignment of structure variables in the C/C++ source code to improve memory access performance.

  USAGE
      devkit advisor cacheline
      [-h | --help]
      {-i INPUT_PATH | --input INPUT_PATH
      [-o OUTPUT_PATH | --output OUTPUT_PATH]
      [-r {all,json,html,csv} | --report-type {all,json,html,csv}]
      [-l {0,1,2,3} | --log-level {0,1,2,3}]
      [--set-timeout TIMEOUT]

  OPTIONS
      -h, --help
      Get help information and exit.

      -i, --input INPUT_PATH
      [Mandatory option] Specifies the path of the source code folder to be scanned.

      -o, --output OUTPUT_PATH
      Specifies the path for storing the scan report and the file name. By default, the file is stored in the current path(pwd) and its name is in the format of function name_timestamp.

      -l, --log-level {0,1,2,3}
      Specifies the log level of the current task, 0(DEBUG) | 1(INFO) | 2(WARNING) | 3(ERROR). The default value is 1(INFO).

      -r, --report-type {all,json,html,csv}
      Specifies the report type for the scan report. The default value is all.

      --set-timeout <min>
      Specifies the timeout period of a task. By default, the timeout period is not set.

  EXAMPLE
      # Scan a project and generate scanning reports.
      devkit advisor cacheline -i /home/advisor/project
```

### 5.9.2 使用命令行进行缓存行对齐检查

#### 命令功能
进行缓存行对齐检查。

#### 命令格式
```shell  
devkit advisor cacheline [-h | --help] {-i INPUT_PATH | --input INPUT_PATH} [-o OUTPUT_PATH | --output OUTPUT_PATH] [-r {all,json,html,csv} | --report-type {all,json,html,csv}] [-l {0,1,2,3} | --log-level {0,1,2,3}] [--set-timeout TIMEOUT]
```

#### 参数说明
**表1 参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>-</td>
    <td>
      获取帮助信息。
    </td>
  </tr>
  <tr>
    <td>-i/--input</td>
    <td>input_path</td>
    <td>
      必选参数，对应的源码文件夹路径。
    </td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>output_path</td>
    <td>
      扫描报告的存放路径，默认存放在当前执行路径下，报告名称为“模块名称_时间戳”。
    </td>
  </tr>
  <tr>
    <td>--set-timeout</td>
    <td>time</td>
    <td>
      任务超时时间，单位为分钟，若执行时间超过超时时间则退出执行。默认无超时时间，任务将持续执行直到结束。
    </td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      设置日志级别，默认为1。<br>
      0：日志级别为DEBUG。<br>
      1：日志级别为INFO。<br>
      2：日志级别为WARNING。<br>
      3：日志级别为ERROR。
    </td>
  </tr>
  <tr>
    <td>-r/--report-type</td>
    <td>all,json,html,csv</td>
    <td>
      扫描报告的格式，默认为all。<br>
      all：生成JSON、HTML、CSV三种格式报告。<br>
      json：生成JSON格式报告。<br>
      html：生成HTML格式报告。<br>
      csv：生成CSV格式报告。
    </td>
  </tr>
</table>

#### 使用实例
以扫描“/home/test_code/vecanalyzer”路径下源码为例，其余均采用默认值，请根据实际情况进行修改。
```shell
devkit advisor cacheline -i /home/test_code/vecanalyzer/ -o /home/out/
```
返回信息如下，输出报告路径。
```shell
Scanned time: 2024/06/12 03:59:22

Configuration: 
    Scan source code path: /home/test_code/vecanalyzer
    Generate report path: /home/out
    Generate report type: all
    Task Timeout Interval: The timeout period is not set.
    Log level: info

Summary: 
    Scanned 3 files, there are 1 recommended modifications. 

For the details information, please check:
/home/out/cacheline_20240612035922_3710.json
/home/out/cacheline_20240612035922_3710.csv
/home/out/cacheline_20240612035922_3710.html
```

## 5.10 动态内存一致性检查
### 5.10.1 命令参数说明
动态内存一致性检查就是检查C/C++源码在鲲鹏平台运行时是否存在动态内存一致性问题（目前仅支持鲲鹏920），并提供动态内存一致性检测结果与插入内存屏障的建议。支持对单进程应用和共享内存模式的多进程应用进行内存一致性动态检查。
#### 命令功能
动态检查源码中是否存在内存一致性问题的情况。

#### 命令格式
```shell
devkit advisor dr-check -h
```

#### 使用实例
执行以下命令，查看所有命令参数说明。
```shell
devkit advisor dr-check -h
```
返回信息如下：
```shell
OVERVIEW
    Run this command to check for dynamic memory consistency problem in the C/C++ source code at the Kunpeng platform
    (Only support Kunpeng 920, 920B, 920C, 920F currently) and provides detected data races.

USAGE
    devkit advisor dr-check
    [-h | --help]
    {-f ELF_FILE | --elf-file ELF_FILE}
    [-i INPUT_PATH | --input INPUT_PATH]
    [-ec {true,false} | --enable-collect {true,false}]
    [--start-collect PID]
    [--stop-collect PID]
    [-s SAFE_FILE | --safe-file SAFE_FILE]
    [-p ELF_PARAMS | --elf-params ELF_PARAMS]
    [-o OUTPUT_PATH | --output OUTPUT_PATH]
    [-sf SHIELD_FILE | --shield-file SHIELD_FILE]
    [-cf CONFIG_FILE | --config-file CONFIG_FILE]
    [-d REPORT_FILE | --decode REPORT_FILE]
    [-sr {true,false} | --summary-report {true,false}]
    [-eb {true,false} | --enable-backtrace {true,false}]
    [-em {true,false} | --enable-multiprocess {true,false}]
    [-dm MP_REPORT | --decode-mp-report MP_REPORT]
    [-r {all,json,html,csv} | --report-type {all,json,html,csv}]
    [-l {0,1,2,3} | --log-level {0,1,2,3}]
    [--set-timeout TIMEOUT]

OPTIONS
    -h, --help
    Get help information and exit.

    -f, --elf-file ELF_FILE
    [Mandatory option] Specifies the binary file in ELF format to be detected.

    -i, --input INPUT_PATH
    Specifies the folder path of the source code to be scanned.

    -ec, --enable-collect {true,false}
    Enable or disable data race collect when starting the task. The default value is true.

    --start-collect <pid>
    Send signal to start data race collecting.

    --stop-collect <pid>
    Send signal to stop data race collecting.

    -s, --safe-file SAFE_FILE
    Specifies the safe functions cfg file that will not be checked for data races during the dynamic memory consistency detection. Need mangled name for C++ function (Viewed by nm command).

    -p, --elf-params ELF_PARAMS
    Specifies the needed input parameters when execute the ELF file. 

    -o, --output OUTPUT_PATH
    Specifies the path for storing the scan report and the file name. By default, the file is stored in the current path(pwd) and its name is in the format of function name_timestamp.

    -sf, --shield-file SHIELD_FILE
    Specifies the files or dynamic libraries that do not participate in the dynamic memory consistency detection.
    
    -cf, --config-file CONFIG_FILE
    Specifies the custom lock that does not check for data contention during the dynamic memory consistency detection.

    -d, --decode REPORT_FILE
    Decode history single-process report file generated during the dynamic memory consistency detection.

    -sr, --summary-report {true,false}
    Enable generate summary report in json format. The default value is false.

    -eb, --enable-backtrace {true,false}
    Enable or disable backtrace recording during the dynamic memory consistency detection. The default value is false.
    
    -em, --enable-multiprocess {true,false}
    Enable or disable multi-process race detection during the dynamic memory consistency detection. The default value is false.

    -dm, --decode-mp-report MP_REPORT
    Decode the generated multi-process report file separately.
    
    -l, --log-level {0,1,2,3}
    Specifies the log level of the current task, 0(DEBUG) | 1(INFO) | 2(WARNING) | 3(ERROR). The default value is 1(INFO).

    -r, --report-type {all,json,html,csv}
    Specifies the report type for the scan report. The default value is all.

    --set-timeout <min>
    Specifies the timeout period of a task. By default, the timeout period is not set.

EXAMPLE
    # Scan a elf file and generate scanning report.
    devkit advisor dr-check -f /home/advisor/elf_file
```
### 5.10.2 使用命令行进行动态内存一致性检查
#### 命令功能
动态检查源码中存在的内存一致性问题。

#### 命令格式
```shell
devkit advisor dr-check [-h | --help] {-f ELF_FILE | --elf-file ELF_FILE} [-i INPUT_PATH | --input INPUT_PATH] [-ec {true,false} | --enable-collect {true,false}] [--start-collect PID] [--stop-collect PID] [-s SAFE_FILE | --safe-file SAFE_FILE] [-p ELF_PARAMS | --elf-params ELF_PARAMS] [-o OUTPUT_PATH | --output OUTPUT_PATH] [-sf SHIELD_FILE | --shield-file SHIELD_FILE] [-cf CONFIG_FILE | --config-file CONFIG_FILE] [-d REPORT_FILE | --decode REPORT_FILE] [-sr {true,false} | --summary-report {true,false}] [-eb {true,false} | --enable-backtrace {true,false}] [-em {true,false} | --enable-multiprocess {true,false}] [-dm MP_REPORT | --decode-mp-report MP_REPORT] [-r {all,json,html,csv} | --report-type {all,json,html,csv}] [-l {0,1,2,3} | --log-level {0,1,2,3}] [--set-timeout TIMEOUT]
```

#### 参数说明
**表1 参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>-</td>
    <td>
      获取帮助信息。
    </td>
  </tr>
  <tr>
    <td>-i/--input</td>
    <td>input_path</td>
    <td>
      ELF文件对应的源码文件夹路径。
    </td>
  </tr>
  <tr>
    <td>-ec/--enable-collect</td>
    <td>true/false</td>
    <td>
      启动应用时是否开启动态内存一致性检查功能，默认为true。<br>
      true：开启动态内存一致性检查功能。<br>
      false：关闭动态内存一致性检查功能。
    </td>
  </tr>
  <tr>
    <td>--start-collect</td>
    <td>PID</td>
    <td>
      对指定的进程发送开启动态内存一致性检查功能信号，指定的进程号为有效的动态内存一致性检查进程。
    </td>
  </tr>
  <tr>
    <td>--stop-collect</td>
    <td>PID</td>
    <td>
      对指定的进程发送关闭动态内存一致性检查功能信号，指定的进程号为有效的动态内存一致性检查进程。
    </td>
  </tr>
  <tr>
    <td>-f/--elf-file</td>
    <td>elf_file</td>
    <td>
      必选参数，ELF文件路径。待测ELF文件必须带有调试信息（编译时增加-g选项）。
    </td>
  </tr>
  <tr>
    <td>-p/--elf-params</td>
    <td>elf_parameter</td>
    <td>
      指定执行ELF文件时所需的输入参数。
    </td>
  </tr>
  <tr>
  <tr>
    <td>-s/--safe-file</td>
    <td>safe_file</td>
    <td>
      cfg配置文件。指定在动态内存一致性检测中不进行检查的安全函数，C++中函数名称需为重载后的函数名称。
    </td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>output_path</td>
    <td>
      扫描报告的存放路径，默认存放在当前执行路径下，报告名称为“模块名称_时间戳”。
    </td>
  </tr>
  <tr>
    <td>-sf/--shield-file</td>
    <td>shield_file</td>
    <td>
      cfg配置文件。指定在动态内存一致性检测当中不参与检查的文件名或动态库。
    </td>
  </tr>
  <tr>
    <td>-cf/--config-file</td>
    <td>config_file</td>
    <td>
      json配置文件。指定在动态内存一致性检测期间不参与检测的用户自定义锁。
    </td>
  </tr>
  <tr>
    <td>-d/--decode</td>
    <td>report_file</td>
    <td>
      历史单进程多线程报告文件。指定运行过程中保存的历史单进程报告文件，最多支持保存5份历史报告，指定该选项后将进行单独对单进程报告解析。
    </td>
  </tr>
  <tr>
    <td>-sr/--summary-report</td>
    <td>true,false</td>
    <td>
      是否生成精简报告，默认为false。<br>
      true：生成精简报告，仅生成json格式。<br>
      false：生成-r选项指定的全量报告。
    </td>
  </tr>
  <tr>
    <td>-eb/--enable-backtrace</td>
    <td>true,false</td>
    <td>
      是否开启调用栈记录，默认为false。<br>
      true：开启调用栈记录。<br>
      false：关闭调用栈记录。
    </td>
  </tr>
  <tr>
    <td>-em/--enable-multiprocess</td>
    <td>true,false</td>
    <td>
      是否开启多进程检测模式，默认为false。<br>
      true：开启多进程检测模式。<br>
      false：关闭多进程检测模式。
    </td>
  </tr>
  <tr>
    <td>-dm/--decode-mp-report</td>
    <td>mp_report</td>
    <td>
      历史多进程报告文件。指定该选项后将单独进行多进程报告解析。
    </td>
  </tr>
  <tr>
    <td>--set-timeout</td>
    <td>time</td>
    <td>
      任务超时时间，单位为分钟，若执行时间超过超时时间则退出执行。默认无超时时间，任务将持续执行直到结束。
    </td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      设置日志级别，默认为1。<br>
      0：日志级别为DEBUG。<br>
      1：日志级别为INFO。<br>
      2：日志级别为WARNING。<br>
      3：日志级别为ERROR。
    </td>
  </tr>
  <tr>
    <td>-r/--report-type</td>
    <td>all,json,html,csv</td>
    <td>
      扫描报告的格式，默认为all。<br>
      all：生成JSON、HTML、CSV三种格式报告。<br>
      json：生成JSON格式报告。<br>
      html：生成HTML格式报告。<br>
      csv：生成CSV格式报告。
    </td>
  </tr>
</table>

#### 使用实例
使用示例此处以扫描“/home/advisor/test”elf文件为例，请根据实际情况进行修改。
```shell
devkit advisor dr-check -f /home/advisor/test
```
返回信息如下，并输出报告。

```shell
Executing dynamic memory consistency check task, please wait...
The pid of the memtracer process is 3517879
Scanned time: 2025/05/14 08:54:50
 
Configuration:
    ELF file path: /home/advisor/test
    Scan source code path: None
    Generate report path: /home/DevKit_Software
    Generate report type: all
    Task Timeout Interval: The timeout period is not set.
    Log level: info
 
Summary:
There are 2 recommended code lines to modify.
 
For the detailed information on multi-thread races, please check:
    /home/DevKit_Software/dr-check_test_20250514085450_0541.json
    /home/DevKit_Software/dr-check_test_20250514085450_0541.html
    /home/DevKit_Software/dr-check_test_20250514085450_0541.csv
```

##### 安全函数使用示例
为支持将包含自定义锁的线程函数标记为安全函数，用户可添加-s/--safe-file参数需指定cfg配置文件，文件中需要在每行写入安全函数的名称。若为cpp文件，必须写入重载后的安全函数名称。
此处以自定义类添加锁为例，请根据实际情况进行添加安全函数。

```shell
class my_custom_spinlock{
    std::atomic_flag is_locked ={false};
public:
  void lock(){
      while (is_locked.test_and_set(std::memory_order_acquire)){}
  }
  
  void unlock (){
      is_locked.clear (std :: memory_order_release);
  }
};
 
int data_race = 0;
 
my_custom_spinlock spinlock;
void* first_thread(void* arg){
    spinlock.lock();
    data_race = 5;
    spinlock.unlock();
    return 0;
}
 
void* second_thread(void* arg){
    spinlock.lock();
    data_race = 3;
    spinlock.unlock();
    return 0;
}
```

通过nm命令可查看first_thread和second_thread函数重载后名称。
```shell
nm test

0000000000400a84 T _Z12first_threadPv
0000000000400ac4 T _Z13second_threadPv
```
则用户可创建配置文件safe_functions.cfg，写入内容：
```shell
_Z12first_threadPv
_Z13second_threadPv
```
此时，执行命令为：
```shell
devkit advisor dr-check -f /home/advisor/test -s /home/testcase/safe_functions.cfg
```
返回信息如下，并输出报告，可以看出无代码行需要修改，实现安全函数过滤操作。
```shell
Executing dynamic memory consistency check task, please wait...
The pid of the memtracer process is 1362149
Scanned time: 2025/05/10 03:15:15

Configuration:
    ELF filepath: /home/advisor/test
    Scan source code path: None
    Generate report path: /home/DevKit_Software
    Generate report type: all
    Task Timeout Interval: The timeout period is not set.
    Log level: info

Summary:
There are 0 recommended code lines to modify.

For the detailed information on multi-thread races, please check:
    /home/DevKit_Software/dr-check_test_20250510031515_663d.json
    /home/DevKit_Software/dr-check_test_20250510031515_663d.html
    /home/DevKit_Software/dr-check_test_20250510031515_663d.csv
```

##### 自定义锁过滤使用示例
为支持对用户自定义的加锁或解锁方法进行识别，可以通过添加-cf/--config-file参数需指定json配置文件，文件中写入需要过滤的自定义加锁和解锁函数。
此处以自定义类添加锁为例，请根据实际情况进行添加自定义加锁或解锁函数。
```shell
class my_custom_spinlock{
    std::atomic_flag is_locked ={false};
public:
  void lock(){
      while (is_locked.test_and_set(std::memory_order_acquire)){}
  }
  
  void unlock (){
      is_locked .clear (std :: memory_order_release);
  }
};
 
int data_race = 0;
 
my_custom_spinlock spinlock;
void* first_thread(void* arg){
    spinlock.lock();
    data_race = 5;
    spinlock.unlock();
    return 0;
}
 
void* second_thread(void* arg){
    spinlock.lock();
    data_race = 3;
    spinlock.unlock();
    return 0;
}
```
对于自定义类锁my_custom_spinlock的过滤，用户可创建配置文件config.json，写入内容：
```shell
{
    "receive": [
        {
            "id_arg": 0,
            "name":"my_custom_spinlock.lock(*)",
            "shared": false,
            "success": "always"
        }
    ],
    "send": [
        {
            "id_arg": 0,
            "name": "my_custom_spinlock.unlock(*)"
        }
    ]
}
```

> ##### 加锁和解锁函数配置选项说明
>receive列表为自定义实现的加锁函数，表示等待资源的函数（与 `pthread_mutex_lock` 原理相似）。
send列表为自定义实现的解锁函数，表示释放资源的函数（与 `pthread_mutex_unlock` 原理相似）。
> 
>加锁和解锁函数共有配置选项字段介绍：
>- **id_arg**：代表在加锁或解锁函数的参数列表中能够代表锁对象的索引（通常情况下，锁对象是一个指针）。
>- **name**：代表加锁/解锁函数名的全称。  
>  - 在 C++ 中，函数名书写方式为`class::function_name(*)`。
>  - 在 C 中，函数名书写方式为`function_name`。
>  - 可以使用`*`匹配或跳过任意字符。
>
>加锁函数特有配置选项字段：
>- **shared**：代表该函数操作的对象是否为读锁。  
>  - 取值范围：`false`或`true`，默认值为`false`。  
>  - 如果是读锁，例如在读写锁上下文中，`shared`字段值为`true`。
>- **success**：代表函数的返回值为何值时表示加锁成功。  
>  - 取值范围（默认值为"always"）：
>    - `always`：表示函数始终成功。
>    - `zero`：表示返回值为0时加锁成功。
>    - `non_zero`：表示返回值为非0时加锁成功。
>  - 如果自定义实现了`try_lock`类型的加锁函数，则根据函数返回值为`0`（对应 `zero`）或非`0`（对应 `non_zero`）来配置该字段。


此时，执行动态内存一致性检查的命令为：
```shell
devkit advisor dr-check -f /home/advisor/test -cf /home/testcase/config.json
```
返回信息如下，并输出报告，可以看出无代码行需要修改，实现自定义锁过滤操作。
```shell
Executing dynamic memory consistency check task, please wait...
The pid of the memtracer process is 1459201
Scanned time: 2025/05/12 07:08:15

Configuration:
    ELF filepath: /home/advisor/test
    Scan source code path: None
    Generate report path: /home/DevKit_Software
    Generate report type: all
    Task Timeout Interval: The timeout period is not set.
    Log level: info

Summary:
There are 0 recommended code lines to modify.

For the detailed information on multi-thread races, please check:
    /home/DevKit_Software/dr-check_test_20250512070815_1256.json
    /home/DevKit_Software/dr-check_test_20250512070815_1256.html
    /home/DevKit_Software/dr-check_test_20250512070815_1256.csv
```

##### 历史单进程报告解析使用示例
用户在成功执行一次动态内存一致性检查命令devkit advisor dr-check后，会在devkit工具文件所在路径下的advisor文件夹中生成一份单进程历史报告文件。用户可以通过使用-d选项针对该单进程报告文件单独解析，执行命令为：
```shell
devkit advisor dr-check -f /home/advisor/test -d ./advisor/test_20250220143014.memtracer_report
```
返回信息与直接执行针对该elf文件的动态内存一致性检查命令除时间信息外保持一致：
```shell
Executing dynamic memory consistency check task, please wait...
Scanned time: 2025/03/17 11:34:46
 
Configuration:
    ELF file path: /home/advisor/test
    Scan source code path: None
    Generate report path: /home/DevKit_Software
    Generate report type: all
    Task Timeout Interval: The timeout period is not set.
    Log level: info
 
Summary:
There are 2 recommended code lines to modify.
 
For the detailed information on multi-thread races, please check:
    /home/DevKit_Software/dr-check_test_20250317113446_c1a0.json
    /home/DevKit_Software/dr-check_test_20250317113446_c1a0.html
    /home/DevKit_Software/dr-check_test_20250317113446_c1a0.csv
```

##### 生成精简报告使用示例
用户可以通过-sr/--summary_report的形式指定是否对单进程报告生成精简报告，使用命令如下：
```shell
devkit advisor dr-check -f /home/advisor/test -sr true
```
返回信息如下，生成的单进程多线程报告将仅包含json格式的精简报告：
```shell
Executing dynamic memory consistency check task, please wait...
The pid of the memtracer process is 1559201
Scanned time: 2025/03/17 11:45:35
 
Configuration:
    ELF file path: /home/advisor/test
    Scan source code path: None
    Generate report path: /home/DevKit_Software
    Generate report type: json
    Task Timeout Interval: The timeout period is not set.
    Log level: info
 
Summary:
There are 2 recommended code lines to modify.
 
For the detailed information on multi-thread races, please check:
    /home/DevKit_Software/dr-check_test_20250317114535_b600.json
```

##### 开启/关闭调用栈使用示例
用户可以通过-eb/--enable-backtrace的形式指定生成的单进程json格式的报告中是否包含调用栈信息，使用命令如下：
```shell
devkit advisor dr-check -f /home/advisor/test -eb true
```
返回信息如下：
```shell
Executing dynamic memory consistency check task, please wait...
The pid of the memtracer process is 1659201
Scanned time: 2025/03/17 11:52:35
 
Configuration:
    ELF file path: /home/advisor/test
    Scan source code path: None
    Generate report path: /home/DevKit_Software
    Generate report type: all
    Task Timeout Interval: The timeout period is not set.
    Log level: info
 
Summary:
There are 2 recommended code lines to modify.
 
For the detailed information on multi-thread races, please check:
    /home/DevKit_Software/dr-check_test_20250317115235_90b5.json
    /home/DevKit_Software/dr-check_test_20250317115235_90b5.html
    /home/DevKit_Software/dr-check_test_20250317115235_90b5.csv
```
注意：开启调用栈后动态内存一致性检查命令devkit advisor dr-check检测到的需要修改的代码行数可能会发生变化；开启/关闭调用栈将为用户提供两种版本的动态内存一致性问题的检测报告，供用户综合考虑。


##### 开启/关闭多进程检测模式使用示例
用户可以通过-em/--enable-multiprocess指定是否开启多进程检测模式，对进程间存在的内存一致性问题进行检测，使用命令如下：
```shell
devkit advisor dr-check -f /home/advisor/test -em true
```
返回信息如下：
```shell
Executing dynamic memory consistency check task, please wait...
The pid of the memtracer process is 1659201
Scanned time: 2025/08/22 01:36:43
 
Configuration:
    ELF file path: /home/advisor/test
    Scan source code path: None
    Generate report path: /home/DevKit_Software
    Generate report type: all
    Task Timeout Interval: The timeout period is not set.
    Log level: info
 
Summary:
There are 2 recommended code lines to modify.
 
For the detailed information on multi-thread races, please check:
    /home/DevKit_Software/dr-check_test_20250822013643_90b5.json
    /home/DevKit_Software/dr-check_test_20250822013643_90b5.html
    /home/DevKit_Software/dr-check_test_20250822013643_90b5.csv
    /home/DevKit_Software/dr-check_test_11237_20250822013643_8075.json
    /home/DevKit_Software/dr-check_test_11237_20250822013643_8075.html
    /home/DevKit_Software/dr-check_test_11237_20250822013643_8075.csv
    
For the detailed information on multi-process races, please check:
    /home/DevKit_Software/dr-check_mp_20250822013643_16c1.html
```
注意：开启多进程检测模式后，动态内存一致性检查命令devkit advisor dr-check检测将多生成一份进程间动态内存一致性问题的检测报告，供用户综合考虑。


##### 历史多进程报告解析使用示例
用户在成功执行一次动态内存一致性检查命令devkit advisor dr-check后，会在devkit工具文件所在路径下的advisor文件夹下，生成mp_report开头的文件夹，里面包含多进程历史报告文件（TXT和JSON格式）。用户可以通过使用-dm选项针对memtracer_report后缀结尾的txt/plain格式的多进程报告文件单独解析，执行命令为：
```shell
devkit advisor dr-check -f /home/advisor/test -dm ./advisor/mp_report_20250826_184410/mp_20250826_184410.memtracer_report
```
生成的报告与直接执行针对该elf文件开启多进程检测模式进行动态内存一致性检查产生的多进程报告内容除时间外保持一致：
```shell
Executing dynamic memory consistency check task, please wait...
Scanned time: 2025/08/26 10:44:10
 
Configuration:
    ELF file path: /home/advisor/test
    Scan source code path: None
    Generate report path: /home/DevKit_Software
    Generate report type: all
    Task Timeout Interval: The timeout period is not set.
    Log level: info
 
Summary:
There are 2 recommended code lines to modify.
 
For the detailed information on multi-process races, please check:
    /home/DevKit_Software/dr-check_mp_20250826104410_cbe3.html
```

#### 输出报告说明
**表2 输出报告说明**
<table>
  <tr>
    <th>参数</th>
    <th>说明</th>
  </tr>
  <tr>
    <td>配置信息</td>
    <td>显示软件源码文件及可执行文件存放路径。</td>
  </tr>
  <tr>
    <td>需要修改的源码文件</td>
    <td>显示存在内存一致性问题，并需要进行修改的源码文件路径等相关信息。</td>
  </tr>
</table>

## 5.11 精度分析工具
### 5.11.1 命令参数说明
精度分析工具用于定位x86和鲲鹏指令引起的Fortran、C/C++语言精度差异问题。
#### 命令功能
查看精度分析工具的命令参数

#### 命令格式
```shell
devkit advisor precision -h
```

#### 使用实例
执行以下命令，查看所有命令参数说明。
```shell
devkit advisor precision -h
```
返回信息如下：
```shell
    "precision": "
OVERVIEW
    Run this command to analysis the precision differences between x86 and Kunpeng platform. For the detail of application scope, please refer to the following document:
    'https://www.hikunpeng.com/document/detail/zh/kunpengdevps/userguide/cliuserguide/KunpengDevKitCli_0086.html'.

USAGE
    #1. devkit advisor precision [-h | --help] {-instrument | --instrument} {-c COMMAND COMMANDS | --commands COMMANDS}
    {-p PROJECT | --project PROJECT} {-e ENTRY | --entry ENTRY} [-v VARIABLE | --variable VARIABLE]
    [-d DEPTH | --depth DEPTH] [-L | --loops] [-D DATABASE| --database DATABASE]
    [-b BLACK_LIST | --black-list BLACK_LIST] [-l {0,1,2,3} | --log-level {0,1,2,3}] [--set-timeout TIMEOUT]

    #2. devkit advisor precision [-h | --help] {-analysis | --analysis} {-i INPUT_LOG | --input INPUT_LOG}
    [-o OUTPUT_PATH | --output OUTPUT_PATH] [-l {0,1,2,3} | --log-level {0,1,2,3}] [--set-timeout TIMEOUT]

OPTIONS
    #1. instrumentation options:
    -instrument | --instrument
    [Mandatory option] Specifies the instrumentation mode.

    -c, --commands COMMANDS
    [Mandatory option] Specifies the build command of the source code. The 'cmake' and 'export' commands are not allowed. They should be run in advance.
    Please ensure that the source code files can be correctly compiled using this command in the current path or the path specified by the 'cd' command, like 'make' or 'cd /home/wrf;./compile em_real' (Need separated by semicolons ';').

    -p, --project PROJECT
    [Mandatory option] Specifies the absolute path of project like '/home/test/project1/' or '/home/project2'.

    -e, --entry ENTRY
    [Mandatory option] Specifies the entry files and corresponding functions. Multiple options are allowed likes '-e demo.f90:main -e demo2.f90:func'. Every file and corresponding functions need separated by colon ':' and multiple functions need separated by comma ','.
    The entry file is the relative path under the project path (-p/--project designated) and must participate in compilation actually, rather than source file before preprocessing. The function should be Mainprogram, Function or Subroutine.

    -v, --variable VARIABLE
    Specifies the variable parameter. When a variable parameter is specified using the -v option, the specified parameter instrumentation mode is enabled.
    All variables within the specified function that affect the specified parameter will be instrumented.
    For example, if we pass -v A, then for assignment 'A = A + B + C', B and C will be instrumented.

    -b, --black-list BLACK_LIST
    Specifies files not involved in instrumentation likes '/home/test/demo1.f90;/home/test/demo2.f90', cannot contain entry file (-e/--entry designated). (must absolute path)

    -d, --depth DEPTH
    Specifies the depth of continuous instrumentation down from the entry function, the range is 0-99. The default depth is 0.

    -L, --loops
    Enable the instrumentation of loops in file.
    [WARNING] The size of precision log file will be increased when running the executable file after instrumentation with this option. Please properly arrange the instrumentation entry and depth.

    -D, --database
    Path of compilation database. Incremental compilation will be performed when specified.

    #2. log analysis options:
    -analysis | --analysis
    [Mandatory option] Specifies the instrumentation log analysis mode.

    -i, --input INPUT_LOG
    [Mandatory option] Specifies the instrumentation log file list (must two items and in the sequence of arm, x86) likes file '/home/arm.log;/home/x86.log' or path '/home/arm/;/home/x86/'.

    -o, --output OUTPUT_PATH
    Specifies the path to save analysis result file. By default, the OUTPUT_PATH is current workspace(pwd).

    #3. common options:
    -h, --help
    Get help information and exit.

    -l, --log-level {0,1,2,3}
    Specifies the log level of the current task, 0(DEBUG) | 1(INFO) | 2(WARNING) | 3(ERROR). The default value is 1(INFO).

    --set-timeout <min>
    Specifies the timeout period of a task. By default, the timeout period is not set.

EXAMPLE
    #1. Run instrumentation in the project directory in both arm and x86 platform: compile and instrumentation.
    devkit advisor precision -instrument -c make -p /home/test/ -e 'demo.f90:main' -e 'test.f90:func' -d 3 -b '/home/test/demo1.f90;/home/test/demo2.f90'

    #2. Re-run the project to get log file in both arm and x86 platform.
        1) Add the libcorrect.mod file path based on the compiler type:
           export LD_LIBRARY_PATH=/Absolute-Path-to-DevKit-CLI/advisor/devkitplugins/affinity/tools/compileopt/libcruiser/gnu_lib(bisheng_lib or user_lib):$LD_LIBRARY_PATH
        2) Add the path of the generated log file.: export CRUISER_LOG=/LOGPATH/
        3) Run the executable file: LD_PRELOAD=libcruiser.so.2:/usr/lib64/libcrypto.so ./XXX
        4) Then collect the two /LOGPATH directories and put them in one of the platform

    #3. Run the analysis to analyze the differences between the arm directory and the x86 directory.
        devkit advisor precision -analysis -i '/home/arm/;/home/x86/'
```
### 5.11.2 使用命令行进行精度分析
#### 命令功能
精度分析工具用于定位x86和鲲鹏指令引起的Fortran、C/C++语言精度差异问题。

#### 命令格式
编译与插桩模式：
```shell
devkit advisor precision [-h | --help] {-instrument | --instrument} {-c COMMAND COMMANDS | --commands COMMANDS}
{-p PROJECT | --project PROJECT} {-e ENTRY | --entry ENTRY} [-v VARIABLE | --variable VARIABLE]
[-d DEPTH | --depth DEPTH] [-L | --loops] [-D DATABASE| --database DATABASE]
[-b BLACK_LIST | --black-list BLACK_LIST] [-l {0,1,2,3} | --log-level {0,1,2,3}] [--set-timeout TIMEOUT]
```
日志分析模式：
```shell
devkit advisor precision [-h | --help] {-analysis | --analysis} {-i INPUT_LOG | --input INPUT_LOG}
[-o OUTPUT_PATH | --output OUTPUT_PATH] [-l {0,1,2,3} | --log-level {0,1,2,3}] [--set-timeout TIMEOUT]
```

#### 参数说明
**表1 编译与插桩模式参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>-</td>
    <td>
      获取帮助信息。
    </td>
  </tr>
  <tr>
    <td>-instrument/--instrument</td>
    <td>-</td>
    <td>
      必选参数，指定编译插桩模式。
    </td>
  </tr>
  <tr>
    <td>-c/--commands</td>
    <td>commands</td>
    <td>
      必选参数，源码的构建命令。若存在多个构建命令需使用英文分号分割并用英文双引号包住，命令中如有空格，也需要用英文双引号包住。
      例如："make all" 或 "cd /home/test;make"。（不接受直接执行cmake命令，需预先执行）
    </td>
  </tr>
  <tr>
    <td>-p/--project</td>
    <td>project</td>
    <td>
      必选参数，项目源码的绝对路径。例如："/home/test/project1/" 或 "/home/project2"。
    </td>
  </tr>
  <tr>
    <td>-e/--entry</td>
    <td>entry</td>
    <td>
      必选参数，指定插桩入口文件和对应的函数，该选项允许多次输入，例如'-e demo.f90:main -e demo2.f90:func'。每个文件和对应的函数需要用英文冒号':'分隔，多个函数需要用英文逗号','分隔。
      入口文件需输入其在项目路径下的相对路径（-p/--project指定），文件实际参与编译，不能为预处理前的源文件。函数为指定Fortran文件中存在的Mainprogram、Function或Subroutine。
    </td>
  </tr>
    <tr>
    <td>-v/--variable</td>
    <td>variable</td>
    <td>
      可选参数，当使用-v选项指定变量参数后，就开启指定参数插桩模式。指定函数内影响指定参数的所有变量都将被插桩。例如，对于‘A = A + B + C’，如果使用-v A，那么也会对B和C进行插桩。
    </td>
  </tr>
  <tr>
    <td>-d/--depth</td>
    <td>depth</td>
    <td>
      从入口函数向下连续插桩的深度，范围为0到99，默认深度为0。
    </td>
  </tr>
  <tr>
    <td>-b/--black-list</td>
    <td>black_list</td>
    <td>
      指定不参与插桩的文件，不能包含-e/--entry参数所指定的插桩入口文件。例如："/home/test/demo1.f90;/home/test/demo2.f90"
    </td>
  </tr>
  <tr>
    <td>-L/--loops</td>
    <td>loops</td>
    <td>
      指定进行循环内插桩。在此选项下，插桩后运行可执行文件生成的精度日志文件大小会增加，请合理安排插桩入口（入口文件、入口函数）和深度。
    </td>
  </tr>
  <tr>
    <td>-D/--database</td>
    <td>database</td>
    <td>
      编译数据库路径，指定时将会进行增量编译，不使用该参数时进行全量编译。
    </td>
  </tr>
</table>

**表2 日志分析模式参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>-</td>
    <td>
      获取帮助信息。
    </td>
  </tr>
  <tr>
    <td>-analysis/--analysis</td>
    <td>-</td>
    <td>
      必选参数，指定日志差异分析模式。
    </td>
  </tr>
  <tr>
    <td>-i/--input</td>
    <td>input_log</td>
    <td>
      必选参数，指定日志文件，输入顺序为arm日志、x86日志（数量为2）。例如：输入文件"/home/arm.log;/home/x86.log" 或路径 "/home/arm/;/home/x86/"。
    </td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>output_path</td>
    <td>
      指定分析结果文件的保存路径。默认为当前工作目录。
    </td>
  </tr>
</table>

**表3 公共参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>-</td>
    <td>
      获取帮助信息。
    </td>
  </tr>
  <tr>
    <td>--set-timeout</td>
    <td>time</td>
    <td>
      任务超时时间，单位为分钟，若执行时间超过超时时间则退出执行。默认无超时时间，任务将持续执行直到结束。
    </td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      设置日志级别，默认为1。<br>
      0：日志级别为DEBUG。<br>
      1：日志级别为INFO。<br>
      2：日志级别为WARNING。<br>
      3：日志级别为ERROR。
    </td>
  </tr>
</table>

#### 使用实例
使用示例此处以扫描“/home/test1/demo1”路径下源码文件为例，请根据实际情况进行修改。
1. 运行编译与插桩模式
```shell
cd /home/test1/demo1/build
cmake ..
devkit advisor precision -instrument -c make -p /home/test1/demo1 -e test.f90:main -d 1
```
返回信息如下。

```shell
Perform the instrumentation and compilation mode.
Finish run precision check tool.
For detail logs on the tool, see /Absolute-Path-to-DevKit-CLI/advisor/logs/preccheck.log and /home/test1/demo1/build/precision_20241106111820_6193.txt
Please check whether error information exists in above two files to ensure that the project can run properly.
Before running the project to get the log file, please add:
  1) the libcorrect.mod file path: export LD_LIBRARY_PATH=/Absolute-Path-to-DevKit-CLI/advisor/devkitplugins/affinity/tools/compileopt/libcruiser/gnu_lib(bisheng_lib or user_lib):$LD_LIBRARY_PATH
  2) the log file path: export CRUISER_LOG=/LOGPATH/
  3) Run the executable file: LD_PRELOAD=libcruiser.so.2:/usr/lib64/libcrypto.so ./XXX"
```

2.运行二进制文件
添加环境变量
1）根据编译器类型添加对应libcruiser库的路径：export LD_LIBRARY_PATH=/Absolute-Path-to-DevKit-CLI/advisor/devkitplugins/affinity/tools/compileopt/libcruiser/gnu_lib(bisheng_lib or user_lib):$LD_LIBRARY_PATH

2）添加生成日志路径：export CRUISER_LOG=/LOGPATH/

3）运行可执行文件：LD_PRELOAD=libcruiser.so.2:/usr/lib64/libcrypto.so ./XXX
```shell
./exec_name
```
4）查看生成的cruiser.log文件，日志内容如下：
```shell
shape_utils.f90|absize|=|28|ins|998058|429d81ed2795e3c586906c6c335aa136
shape_utils.f90|absize|=|28|ins|998058|429d81ed2795e3c586906c6c335aa136
test.f90|main|absize|26|array1d|998058|22160b46bba283274412c4033f1f33fe
shape_utils.f90|absize|=|28|ins|998058|429d81ed2795e3c586906c6c335aa136
test.f90|main|xysize|35|x2|998058|5d5ebe7707f02dec747fd0d111d0f83c
test.f90|main|submain|41|array1d|998058|22160b46bba283274412c4033f1f33fe
shape_utils.f90|absize|=|28|ins|999991|429d81ed2795e3c586906c6c335aa136
shape_utils.f90|absize|=|28|ins|999991|429d81ed2795e3c586906c6c335aa136
test.f90|main|absize|26|array1d|999991|234cfaa1bd6890a32de5483968406a9a
shape_utils.f90|absize|=|28|ins|999991|429d81ed2795e3c586906c6c335aa136
```

3.日志分析模式

```shell
devkit advisor precision -analysis -i "/home/test_cruiser_kp/;/home/test_cruiser_x86/"
```

返回信息如下。

```shell
Perform the logs analysis mode.
Finish run precision check tool.
For detail logs on the tool, see /Absolute-Path-to-DevKit-CLI/advisor/logs/preccheck.log
The analysis result is in /home/precision_20241106113405_5b7a.txt
```
查看生成的/home/precision_20241106113405_5b7a.txt文件，定位源码，查找精度问题。

## 5.12 链路时延检测工具
### 5.12.1 命令参数说明
链路时延检测工具用于挂载用户态函数耗时采集库到运行中的进程；或分析采集到的函数调用信息，根据分析结果生成时序图和校验兼容性。
#### 命令功能
查看链路时延检测工具的命令参数

#### 命令格式
```shell
devkit advisor knet -h
```

#### 使用实例
执行以下命令，查看attach模式、时序图和兼容性所对应的参数。
```shell
devkit advisor knet -h
```
返回信息如下：
```shell
OVERVIEW
    Run this command to analyze the function call information collected by librecord.so, generate a sequence diagram or display compatibility.

USAGE
    devkit advisor knet [POSITIONAL ARGUMENTS] [OPTIONS]

POSITIONAL ARGUMENTS
    {seq-diag,compat,attach}   Modes of KNet
    seq-diag            Analyze and Display the Sequence Diagram
    compat              Analyze and Display the Compatibility
    attach              Attach the collector(librecord.so) to a running process

OPTIONS
    -l {0,1,2,3}, --log-level {0,1,2,3}
    Specifies the log level of the current task. The default value is INFO.

    --set-timeout TIMEOUT
    Specifies the timeout period of a task. By default, the timeout period is not set.


```
### 5.12.2 使用命令行生成时序图/校验兼容性/以attach模式采集进程

#### 命令格式
生成时序图：
```shell
devkit advisor knet [-h | --help] {seq-diag} {-d DIR_OF_RECORDED_DATA} {-o OUTPUT_FILE_PATH} [-l {0,1,2,3} | --log-level {0,1,2,3}] [--set-timeout TIMEOUT]
```
校验兼容性：
```shell
devkit advisor knet [-h | --help] {compat} {-d DIR_OF_RECORDED_DATA} {-c JSON_CONF_FILE_PATH} [-l {0,1,2,3} | --log-level {0,1,2,3}] [--set-timeout TIMEOUT]
```
attach模式采集：
```shell
devkit advisor knet [-h | --help] {attach} {-i CONF_FILE_PATH} {-o OUTPUT_DIR_PATH} {-p PROCESS_ID} [-l {0,1,2,3} | --log-level {0,1,2,3}] [--set-timeout TIMEOUT]
```

#### 参数说明
**表1 时序图模式参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>-</td>
    <td>
      获取帮助信息。
    </td>
  </tr>
  <tr>
    <td>-o</td>
    <td>OUTPUT_FILE_PATH</td>
    <td>
      必选参数，指定待输出的时序图文件压缩包的路径。
    </td>
  </tr>
  <tr>
    <td>-d</td>
    <td>DIR_OF_RECORDED_DATA</td>
    <td>
      必选参数，指定存放数据文件的目录。
    </td>
  </tr>
</table>

**表2 兼容性模式参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>-</td>
    <td>
      获取帮助信息。
    </td>
  </tr>
  <tr>
    <td>-c</td>
    <td>JSON_CONF_FILE_PATH</td>
    <td>
      必选参数，指定json格式的兼容性配置文件的路径。
      <blockquote>工具提供配置文件模板compat_conf.json， 配置文件模板路径为“/root/CLI/DevKit-CLI-xxx-Linux-Kunpeng/advisor/devkitplugins/affinity/tools/compileopt/templates/compat_conf.json”。
“/root/CLI/DevKit-CLI-xxx-Linux-Kunpeng/”为命令行工具安装路径。</blockquote>
    </td>
  </tr>
  <tr>
    <td>-d</td>
    <td>DIR_OF_RECORDED_DATA</td>
    <td>
      必选参数，指定存放数据文件的目录。
    </td>
  </tr>
</table>

**表3 attach采集模式参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>-</td>
    <td>
      获取帮助信息。
    </td>
  </tr>
  <tr>
    <td>-i</td>
    <td>CONF_FILE_PATH</td>
    <td>
      必选参数，指定配置文件的路径。
    </td>
  </tr>
  <tr>
    <td>-o</td>
    <td>OUTPUT_DIR_PATH</td>
    <td>
      必选参数，指定输出的采集数据文件的目录。
    </td>
  </tr>
  <tr>
    <td>-p</td>
    <td>PROCESS_ID</td>
    <td>
      必选参数，指定待挂载采集库的二进制的进程ID。
    </td>
  </tr>
</table>

**表4 公共参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>-</td>
    <td>
      获取帮助信息。
    </td>
  </tr>
  <tr>
    <td>--set-timeout</td>
    <td>time</td>
    <td>
      任务超时时间，单位为分钟，若执行时间超过超时时间则退出执行。默认无超时时间，任务将持续执行直到结束。
    </td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      设置日志级别，默认为1。<br>
      0：日志级别为DEBUG。<br>
      1：日志级别为INFO。<br>
      2：日志级别为WARNING。<br>
      3：日志级别为ERROR。
    </td>
  </tr>
</table>

#### 使用示例

###### 步骤1
源文件为test_posix.c，编译源文件生成二进制文件test_posix。
```shell
gcc /home/demo/test_posix.c -o /home/demo/test_posix -pthread
```
###### 步骤2
以“/home/demo/config.txt”配置文件，test_posix二进制文件为例，采集二进制运行时的POSIX函数调用及参数信息。

```shell
cd /home/demo/
LD_PRELOAD=librecord.so RECORD_CONF=config.txt RECORD_OUT_DIR=/home/demo/data/ ./test_posix
```
也可以使用attach模式进行采集。

```shell
cd /home/demo/
./test_posix

devkit advisor knet attach -i /home/demo/config.txt -o /home/demo/data/ -p $(pgrep test_posix)
```
config.txt配置文件内容：
```
socket
bind
listen
connect
getpeername
getsockname
send
recv
read
write
fcntl
accept4
setsockopt
close
signal
fork
select
```
在“/home/demo/data/”路径下生成对应的数据文件，数据文件可以是1个或多个。
###### 步骤3
查看生成的数据文件
```shell
ls /home/demo/data/
```
返回信息如下：
```shell
record.3649201  record.3649202  record.3649259  record.3649260  record.3649261  record.3649262  record.3649263  record.3649264  record.3649265  record.3649266
```
在“/home/demo/data/”下生成10个数据文件。
###### 步骤4
查看数据文件内容
```shell
vim /home/demo/data/record.3649201
```
record.3649201数据文件内容：
```shell
1 36702160 3649201 3649201 3649201 3649201 3111602
0 fork 36625210 36910470 285260 3649202 0
0 socket 1037031630 1037053970 22340 4 3 2 1 0
0 connect 1037099200 1037167150 67950 0 3 4 P1{sin_family:2,sin_port:33315,sin_addr:{s_addr:16777343}} 16 16777343 39623
0 getsockname 1037304820 1037306380 1560 0 3 4 P1{sin_family:2,sin_port:39623,sin_addr:{s_addr:16777343}} P1{16}
0 getpeername 1037384790 1037385880 1090 0 3 4 P1{sin_family:2,sin_port:33315,sin_addr:{s_addr:16777343}} P1{16}
0 fcntl 1037458160 1037460140 1980 2 3 4 3 0
0 fcntl 1037465900 1037467060 1160 0 3 4 4 2050
0 pthread_create 1037481550 1037544030 62480 0 4 P1 P0 P1 P1
0 pthread_create 1037551390 1037579390 28000 0 4 P1 P0 P1 P1
0 pthread_create 1037585300 1037668480 83180 0 4 P1 P0 P1 P1
0 pthread_create 1037675450 1037702300 26850 0 4 P1 P0 P1 P1
3 18073
```
###### 步骤5
以“/home/demo/data/”数据文件存放路径为例，展示时序图及网络数据。
```shell
devkit advisor knet seq-diag -d /home/demo/data -o /home/demo
```
执行后会在“/home/demo”目录下生成knet-analysis_时间戳.tar.gz压缩包。将压缩包下载到本地进行解压，解压后打开文件夹并运行knet-analysis.exe文件，在打开的界面中分别展示网络数据概览和更加精细的时序图信息。当一组消息簇包含的信息过多，则使用热力图显示整体的消息分布。单击热力图下钻到时序图，提高信息的识别。

**表**1 网络数据概览图说明
<table>
  <tr>
    <th>数据</th>
    <th>数据说明</th>
  </tr>
  <tr>
    <td>网络IO占比</td>
    <td>获取和网络通讯相关的读/写等IO函数，累加耗时，得到网络IO耗时；获取应用的user time，认为是用户态耗时。</td>

  </tr>
  <tr>
    <td>网络通信时延</td>
    <td>累加所有读/写等接口耗时，除以总包数，以1ms为间隔。</td>
  </tr>
  <tr>
    <td>通讯带宽</td>
    <td>累加所有读/写等接口包长，除以时间，以1ms为间隔。</td>
  </tr>
  <tr>
    <td>包率</td>
    <td>累加所有读/写等接口个数，除以时间，以1ms为间隔。</td>
  </tr>
</table>

**表**2 时序图说明
<table>
  <tr>
    <th>数据</th>
    <th>数据说明</th>
  </tr>
  <tr>
    <td>线程数</td>
    <td>运行的线程总数。</td>

  </tr>
  <tr>
    <td>消息数</td>
    <td>发送、接收、读、写的消息总数。</td>
  </tr>
  <tr>
    <td>序号</td>
    <td>行数。</td>
  </tr>
  <tr>
    <td>线程</td>
    <td>线程号。</td>
  </tr>
</table>

###### 步骤6
以工具提供的兼容性配置文件（“/home/demo/compat_conf.json”）为例，展示兼容性。
```shell
devkit advisor knet compat -d /home/demo/data -c /home/demo/compat_conf.json
```
返回信息如下：
```shell
=====ERROR: some function calls do not satisfy conditions======
[Function call] socket 2 1 0
[Condition] Operation Not Allowed: Socket creation in child processes is forbidden. (PID: 3649202)

[Function call] fcntl 4 3 0
[Condition] arg 2 should only have these flags: 2048

[Function call] fcntl 4 4 2050
[Condition] arg 2 should only have these flags: 2048

[Function call] fcntl 4 3 0
[Condition] arg 2 should only have these flags: 2048

[Function call] fcntl 4 4 2050
[Condition] arg 2 should only have these flags: 2048

[Function call] send 4 P1 11 0
[Condition] arg 3 should only have these flags: 64
...
===============================================================
K-NET tools executed successfully.
```
从回显信息可以看出，socket()、fcntl()、send()函数不兼容。
# 6 系统性能分析

## 6.1 介绍

### 命令功能
查看系统性能分析支持任务的帮助信息。

### 命令格式
查看所有命令参数说明。
```shell
devkit tuner -h
```

### 使用实例
运行以下命令，查看所有命令参数说明。
```shell
devkit tuner -h
```
返回信息如下：
```shell
Usage: devkit tuner [--help] TASK [ARGS]

 The most commonly used devkit tuner sub tasks are:
   help       Get help information
   top-down   Run the top-down collection and analysis task
   hotspot    Run the hotspot collection and analysis task
   miss       Run the miss collection and analysis task
   numafast   Run the numafast collection and analysis task
   hpc-perf   Run the hpc-perf collection and analysis task
   roofline   Run the roofline collection and analysis task
   memory     Run the memory collection and analysis task

 See 'devkit tuner TASK --help' for more information on a specific task.
```

## 6.2 微架构分析

### 命令功能
基于ARM PMU（Performance Monitor Unit）事件，获得指令在CPU流水线上的运行情况，帮助用户快速定位当前应用在CPU上的性能瓶颈。用户可以有针对性地修改自己的程序，以充分利用当前的硬件资源。

### 命令格式
```shell
devkit tuner top-down [-h] [-c {n | n,m | n-m}] [-d <sec>] [-D <sec>] [-l {0, 1, 2, 3}] [-L {0, 1, 2, 3, 4, 5, 6}] [-i <sec>] [-p {PID | PID1,PID2 | ALL}] [-r {user, kernel, all}] [-o] [--package] [workload workload...]
```

### 参数说明
**表1 参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-c/--cpu</td>
    <td>core_num</td>
    <td>
      指定采集的CPU核数。<br>
      如“0”、“0,1,2”、“0-2”。
    </td>
  </tr>
  <tr>
    <td>-d/--duration</td>
    <td>Num</td>
    <td>
      设置采集时长，单位为秒，最小值为1秒，默认为一直采集。<br>
      可使用Ctrl+\取消任务或Ctrl+C组合键停止采集并进入分析。
    </td>
  </tr>
  <tr>
    <td>-i/--interval</td>
    <td>Num</td>
    <td>
      设置采集间隔，默认为1秒；若已设置采集时长，需小于等于采集时长。
    </td>
  </tr>
  <tr>
    <td>-D/--delay</td>
    <td>Num</td>
    <td>
      设置延迟采集时长，默认为0秒，且需小于采集时长。
    </td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      配置日志等级。默认值为1(info)。<br>
      - 0（debug）<br>
      - 1（info）<br>
      - 2（warning）<br>
      - 3（error）
    </td>
  </tr>
  <tr>
    <td>-L/--profile-level</td>
    <td>0,1,2,3,4,5,6</td>
    <td>
      设置分析指标，不设置时默认为0。<br>
      - 0代表ALL，默认值，将同时针对以下所有维度进行采集。
      - 1代表level 1，将会采集Backend Bound，Bad Speculation，Frontend Bound，Retiring。<br>
      - 2代表Backend Bound->Core Bound：Backend是处理器处理机制的后置部分，它负责微指令的乱序分发和执行，并返回最终结果。Core Bound是Backend Bound的子类，该指标能够反映出由于处理器执行单元资源不足导致性能瓶颈的比例情况。<br>
      - 3代表Backend Bound->Memory Bound：Backend是处理器处理机制的后置部分，它负责微指令的乱序分发和执行，并返回最终结果。Memory Bound是Backend Bound的子类，该指标能够反映出由于等待数据读/写导致的流水线阻塞。<br>
      - 4代表Backend Bound->Resource Bound：（支持鲲鹏920系列处理器）Back-End是处理器处理机制的后置部分，它负责微指令的乱序分发和执行，并返回最终结果。Resource Bound是Back-End Bound的子类，该指标能够反映出由于缺乏资源把微指令分发给乱序执行调度器，从而导致的流水线阻塞情况。<br>
      - 5代表Bad Speculation：该指标能够反映出由于错误的指令预测操作导致的流水线资源浪费情况。<br>
      - 6代表Frontend Bound：该指标代表了处理器处理机制的前置部分，在该部分，指令获取单元负责指令的获取并转化为微指令提供给后置部分的流水线执行。该指标能够反映出处理器前置部分没有被充分利用的比例情况。
    </td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>file</td>
    <td>
      设置报告数据生成文件名，默认生成在当前所在目录。
    </td>
  </tr>
  <tr>
    <td>-p/--pid</td>
    <td>PID</td>
    <td>
      指定采集的进程PID，多个进程PID可用“,”分隔。<br>
      指定ALL可采集整个系统的PID。<br>
      若同时使用-p和-c参数则优先采集指定PID的进程。若不指定默认采集全部进程。
    </td>
  </tr>
  <tr>
    <td>-r/--collection-range</td>
    <td>user/kernel/all</td>
    <td>
      设置采集进程的等级，当-p/--pid设置为ALL时，可以收集内核模式进程或用户模式进程。默认为all（采集用户态和内核态的性能数据）。
<br>
      - user：采集用户态的性能数据
<br>
      - kernel：采集内核态的性能数据
<br>
      - all：采集用户态和内核态的性能数据
<br>
    </td>
  </tr>
  <tr>
    <td>--package</td>
    <td>--</td>
    <td>
      设置是否将数据导入数据库，并在指定输出路径中生成压缩包。
    </td>
  </tr>
</table>


### 使用示例
- 针对CPU采集
命令：
```shell
devkit tuner top-down -c 0-127 -d 3 -o /home/topdown_cpu -L 2 --package
```
```text
[说明]
该命令参数-c 0-127采集0到127的CPU核，采集时长为3秒，
参数-o /home/topdown_cpu和--package生成以topdown_cpu命名的报告数据压缩包至指定路径，
参数-L 2为采集Backend Bound->Core Bound指令数据。
```
结果回显

```shell
TOP-DOWN Summary Report-ALL                    Time:2025/09/05 09:56:46
=======================================================================

Top-down metrics of CPU(s) 0-127:
Cycles              37,557,176,489
Instructions        22,687,713,004
IPC                 0.60

────────────────────────────────────────────────────────────────────────────────
  Top-down Metrics                         Bound(%)    Preferred Sampling Event
────────────────────────────────────────────────────────────────────────────────
  Bad Speculation                             0.44    --

  Frontend Bound                              7.87    --

  Retiring                                   10.06    inst_retired

  Backend Bound                              81.63    --
  ├── Core Bound                             57.32    --
  │   ├── FDIV Stall                          0.00    --
  │   ├── DIV Stall                           0.00    --
  │   ├── FSU Stall                           0.00    --
  │   └── Exe Ports Util                     57.32    --
  │       ├── 0 ports serialize              12.13    --
  │       ├── 0 ports non serialize           9.65    --
  │       ├── 1 ports                         9.48    --
  │       ├── 2 ports                         9.49    --
  │       ├── 3 ports                         7.60    --
  │       ├── 4 ports                         5.29    --
  │       ├── 5 ports                         2.38    --
  │       └── 6p ports                        1.30    --
  └── Memory Bound                           24.31    --
────────────────────────────────────────────────────────────────────────────────
3026 milliseconds time elapsed

Note: To view the hotspot data. You can run devkit tuner hotspot -e [Preferred Sampling Event]

The report /home/topdown_cpu.tar is generated successfully.
To view summary report. you can run: devkit report -i /home/topdown_cpu.tar
To view detail report. you can import the report to the WebUI or IDE to view details.

```

- 针对PID采集
命令：
```shell
devkit tuner top-down -p 1333987 -d 3 -o /home/topdown_pid --package
```
```text
[说明]
该命令参数-p 1333987采集PID为1333987的进程，采集时长为3秒，
参数-o /home/topdown_pid和--package生成以topdown_pid命名的报告数据压缩包至指定路径，
未指定参数-L则采集Backend Bound，Bad Speculation，Frontend Bound，Retiring指令数据。
```
结果回显

```shell
TOP-DOWN Summary Report-ALL                    Time:2025/09/05 10:12:51
=======================================================================

Top-down metrics of process id '1333987':
Cycles              17,364,016,063
Instructions        18,055,768,111
IPC                 1.04

────────────────────────────────────────────────────────────────────────────────
  Top-down Metrics                         Bound(%)    Preferred Sampling Event
────────────────────────────────────────────────────────────────────────────────
  Bad Speculation                            10.26    --
  ├── Branch Mispredicts                      0.00    br_mis_pred
  │   ├── Indirect Branch                     0.00    --
  │   ├── Push Branch                         0.00    --
  │   ├── Pop Branch                          0.00    --
  │   └── Other Branch                        0.00    --
  └── Machine Clears                         10.25    --
      ├── Nuke Flush                         10.25    --
      └── Other Flush                         0.00    --

  Frontend Bound                              2.78    --
  ├── Fetch Latency Bound                     0.41    --
  │   ├── ITLB Miss                           0.00    --
  │   ├── ICache Miss                         0.00    --
  │   ├── BP_Misp_Flush                       0.00    br_mis_pred
  │   ├── OoO Flush                           0.41    --
  │   └── Static Predictor Flush              0.00    --
  └── Fetch Bandwidth Bound                   2.37    --

  Retiring                                   17.33    inst_retired

  Backend Bound                              69.63    --
  ├── Core Bound                             69.52    --
  │   ├── FDIV Stall                          0.00    --
  │   ├── DIV Stall                           0.00    --
  │   ├── FSU Stall                           0.00    --
  │   └── Exe Ports Util                     69.52    --
  │       ├── 0 ports serialize               0.00    --
  │       ├── 0 ports non serialize           0.28    --
  │       ├── 1 ports                         3.20    --
  │       ├── 2 ports                        11.24    --
  │       ├── 3 ports                        17.02    --
  │       ├── 4 ports                        17.31    --
  │       ├── 5 ports                        12.64    --
  │       └── 6p ports                        7.83    --
  └── Memory Bound                            0.11    --
      ├── L1 Bound                            0.10    --
      │   ├── DTLB                            0.00    --
      │   ├── Misalign                        0.00    --
      │   ├── Resource Full                   0.00    --
      │   ├── Instruction Type                0.00    --
      │   ├── Forward hazard                  0.08    --
      │   ├── Structure hazard                0.01    --
      │   └── Pipeline                        0.01    --
      ├── L2 Bound                            0.00    --
      │   ├── buffer pending                  0.00    --
      │   ├── snoop pending                   0.00    --
      │   ├── Arb idle                        0.00    --
      │   └── Pipeline                        0.00    --
      ├── L3 or DRAM Bound                    0.00    --
      └── Store Bound                         0.01    --
          ├── SCA                             0.00    --
          ├── Head                            0.00    --
          ├── Order                           0.00    --
          └── Other                           0.01    --
────────────────────────────────────────────────────────────────────────────────
3000 milliseconds time elapsed

Note: To view the hotspot data. You can run devkit tuner hotspot -e [Preferred Sampling Event]

Optimization Suggestions

    1. The percentage of Backend Bound is high.(Threshold: 20.00%)
       Take the following optimization measures for C/C++ applications compiled using the BiSheng compiler. For other compilers, you can refer to the
       optimization suggestions. Verify the optimization suggestions in your specific application scenario.
       (1) Use the jemalloc library. Associate the libjemalloc.so soft link in the lib directory of the BiSheng compiler with the jemalloc dynamic
       library entity whose size is the same as the system page table size in this directory, and add the -ljemalloc parameter for the compilation.
       (2) Set Wrap-memset/memcpy: Wl,-wrap=memset/memcpy -lstringlib. The BiSheng compiler provides memset/memcpy implementation in the libstring
       library, which is more adaptable to the AArch64 architecture. When the glibc version is earlier and the function proportion is high, the
       performance is significantly improved.
       (3) Set prefetch to save the data to be accessed to the cache, so as to reduce the value of d-cache miss. The hardware has its own prefetch
       mechanism. The compiler supports the software prefetch function. When tsv110 is enabled, the BiSheng compiler automatically enables software
       prefetch. You can adjust the prefetch density by using the three parameters: -mllvm -prefetch-loop-depth=x -mllvm -min-prefetch-stride=y -mllvm
       -prefetch-distance=z, where for example, x=3, y=9, z=940.
       (4) Add the -fstack-arrays parameter to place all arrays onto the stack. The parameter takes effect only on Fortran.
       (5) Try enabling huge pages.


The report /home/topdown_pid.tar is generated successfully.
To view summary report. you can run: devkit report -i /home/topdown_pid.tar
To view detail report. you can import the report to the WebUI or IDE to view details.

```

- 针对APP采集
命令：
```shell
devkit tuner top-down -d 10 -o /home/topdown_app -L 2 --package /opt/testdemo/falsesharinglong
```
```text
[说明]
该命令对程序/opt/testdemo/falsesharinglong进行采集，采集时长为10秒（若应用本身运行时长短于10， 任务会提前结束），
对呈现参数-o /home/topdown_app和--package生成以topdown_app命名的报告数据压缩包至指定路径，
参数-L 2为采集Backend Bound->Core Bound指令数据。
```
结果回显

```shell
TOP-DOWN Summary Report-ALL                    Time:2025/09/05 10:15:28
=======================================================================

Top-down metrics of /opt/testdemo/falsesharinglong:
Cycles              28,989,253,884
Instructions        36,870,180,701
IPC                 1.27

────────────────────────────────────────────────────────────────────────────────
  Top-down Metrics                         Bound(%)    Preferred Sampling Event
────────────────────────────────────────────────────────────────────────────────
  Bad Speculation                             3.78    --

  Frontend Bound                              0.97    --

  Retiring                                   21.19    inst_retired

  Backend Bound                              74.05    --
  ├── Core Bound                             73.99    --
  │   ├── FDIV Stall                          0.00    --
  │   ├── DIV Stall                           0.00    --
  │   ├── FSU Stall                           0.00    --
  │   └── Exe Ports Util                     73.99    --
  │       ├── 0 ports serialize               0.00    --
  │       ├── 0 ports non serialize           0.12    --
  │       ├── 1 ports                         2.20    --
  │       ├── 2 ports                        11.39    --
  │       ├── 3 ports                        20.67    --
  │       ├── 4 ports                        20.56    --
  │       ├── 5 ports                        12.73    --
  │       └── 6p ports                        6.32    --
  └── Memory Bound                            0.06    --
────────────────────────────────────────────────────────────────────────────────
10000 milliseconds time elapsed

Note: To view the hotspot data. You can run devkit tuner hotspot -e [Preferred Sampling Event]

Optimization Suggestions

    1. The percentage of Backend Bound is high.(Threshold: 20.00%)
       Take the following optimization measures for C/C++ applications compiled using the BiSheng compiler. For other compilers, you can refer to the
       optimization suggestions. Verify the optimization suggestions in your specific application scenario.
       (1) Use the jemalloc library. Associate the libjemalloc.so soft link in the lib directory of the BiSheng compiler with the jemalloc dynamic
       library entity whose size is the same as the system page table size in this directory, and add the -ljemalloc parameter for the compilation.
       (2) Set Wrap-memset/memcpy: Wl,-wrap=memset/memcpy -lstringlib. The BiSheng compiler provides memset/memcpy implementation in the libstring
       library, which is more adaptable to the AArch64 architecture. When the glibc version is earlier and the function proportion is high, the
       performance is significantly improved.
       (3) Set prefetch to save the data to be accessed to the cache, so as to reduce the value of d-cache miss. The hardware has its own prefetch
       mechanism. The compiler supports the software prefetch function. When tsv110 is enabled, the BiSheng compiler automatically enables software
       prefetch. You can adjust the prefetch density by using the three parameters: -mllvm -prefetch-loop-depth=x -mllvm -min-prefetch-stride=y -mllvm
       -prefetch-distance=z, where for example, x=3, y=9, z=940.
       (4) Add the -fstack-arrays parameter to place all arrays onto the stack. The parameter takes effect only on Fortran.
       (5) Try enabling huge pages.


The report /home/topdown_app.tar is generated successfully.
To view summary report. you can run: devkit report -i /home/topdown_app.tar
To view detail report. you can import the report to the WebUI or IDE to view details.

```

以上界面回显为微架构分析任务的总览信息，时序信息可通过--package参数打包生成TAR包，导入Web界面查看图形化信息。

## 6.3 HPC应用分析

### 命令功能
采集系统的PMU事件并配合采集面向OpenMP和MPI应用的关键指标，帮助用户精准获得Parallel region及Barrier-to-Barrier的串行及并行时间、校准的2层微架构指标、指令分布及L3的利用率和内存带宽等信息。

>[说明]
>- 多节点场景下，工具需解压或安装在共享目录下。多节点时需自行指定节点，即-H参数添加节点信息。
>- 已生成TAR包的任务可导入Web界面进行图形可视化的查看，导入详情请参见任务管理中的任务导入部分内容。
>- 需在mpirun命令下运行，命令后需添加应用。

### 命令格式

```shell
mpirun -n 4 devkit tuner hpc-perf <command> [<options>]
```

>[说明]
>- mpirun原始命令为：mpirun -n 4 <command> [<options>]
>- 示例均为RPM包安装使用，若使用压缩包方式需使用绝对路径，如“/home/DevKit-CLI-x.x.x-Linux-Kunpeng/devkit tuner”。
>- 若使用普通用户运行命令，须先确保任务的计算节点 /proc/sys/kernel/perf_event_paranoid的值为-1，/proc/sys/kernel/kptr_restrict的值为0。

### 参数说明
**表1 参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>file</td>
    <td>
      生成的数据包路径名称。<br>
      默认生成在工具数据路径下。
    </td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      配置日志等级。默认值为1(info)。<br>
      - 0（debug）<br>
      - 1（info）<br>
      - 2（warning）<br>
      - 3（error）
    </td>
  </tr>
  <tr>
  <td>-d/--duration</td>
    <td>Num</td>
    <td>
      设置采集时长，单位为秒，不设置时默认为一直采集。
    </td>
  </tr>
  <tr>
    <td>-L/--profile-level</td>
    <td>summary,detail,graphic</td>
    <td>
      设置分析指标，不设置时默认为1。<br>
      设置任务采集类型，不指定时默认为summary。<br>
      - summary为采集基础指标，采集分析开销较小。<br>
      - detail为采集热点函数及详细指标，采集分析开销较大。<br>
      - graphic为采集通信热力图/时序图信息，采集分析开销最大。
    </td>
  </tr>
  <tr>
    <td>--critical-path</td>
    <td>--</td>
    <td>
      设置是否采集critical path。<br>
      任务采集类型为summary和detail可选。
    </td>
  </tr>
  <tr>
    <td>--mpi-only</td>
    <td>--</td>
    <td>
      设置是否只采集mpi指标。<br>
      任务采集类型为summary和detail可选。
    </td>
  </tr>
  <tr>
    <td>--call-stack</td>
    <td>--</td>
    <td>
      设置是否采集callstack信息。<br>
      任务采集类型为graphic可选。
    </td>
  </tr>
  <tr>
    <td>--rank-fuzzy</td>
    <td>Num</td>
    <td>
      指定模糊化倍率。默认为12800。<br>
      任务采集类型为graphic可选。
    </td>
  </tr>
  <tr>
    <td>--region-max</td>
    <td>>1000</td>
    <td>
      指定时序图中显示的通信区域的数量。默认值为1000，设置时该值需大于1000。<br>
      任务采集类型为graphic可选。
    </td>
  </tr>
  <tr>
    <td>--rdma-collect</td>
    <td>1-15</td>
    <td>
      指定收集RDMA性能指标的采样间隔，若未指定该参数将不采集RDMA性能指标。范围为1到15秒。<br>
      任务采集类型为graphic可选。
    </td>
  </tr>
  <tr>
    <td>--shared-storage</td>
    <td>1-15</td>
    <td>
      指定收集共享文件夹性能指标的采样间隔，若未指定该参数将不采集RDMA性能指标。范围为1到15秒。<br>
      任务采集类型为graphic可选。
    </td>
  </tr>
</table>


### 使用示例
- 任务类型为summary，采集基础指标。

    命令：

    ```shell
    /opt/ompi/bin/mpirun --allow-run-as-root -H 1.2.3.4:1 devkit tuner hpc-perf /opt/test/testdemo/ring
    ```

    >[说明]
    >
    >-L参数不指定默认采集summary等级的数据。

    结果回显

    ```shell
    [Rank000][localhost.localdomain] =======================================PARAM CHECK=======================================
    [Rank000][localhost.localdomain] PARAM CHECK success.
    [Rank000][localhost.localdomain] ===================================PREPARE FOR COLLECT===================================
    [Rank000][localhost.localdomain] preparation of collection success.
    [Rank000][localhost.localdomain] ==================================COLLECT AND ANALYSIS ==================================
    Collection duration: 1.00 s, collect until application finish
    Collection duration: 2.01 s, collect until application finish
    Collection duration: 3.01 s, collect until application finish
    ...
    ...
    ...
    Time measured: 0.311326 seconds.
    Collection duration: 4.01 s, collect until application finish
    Collection duration: 5.02 s, collect until application finish
    Collection duration: 6.02 s, collect until application finish
    done
    Resolving symbols...done
    Symbols reduction...done
    Calculating MPI imbalance...0.0011 sec
    Aggregating MPI/OpenMP data...done
    Processing hardware events data started
    Reading perf trace...Reading perf trace...Reading perf trace...Reading perf trace...Reading perf trace...Reading perf trace...Reading perf trace...Reading perf trace...Reading perf trace...Reading perf trace...Collection duration: 7.03 s, collect until application finish
    0.173 sec
    Sorting samples...0.173 sec
    Sorting samples...0.000 sec
    Loading MPI critical path segments...0.000 sec
    Sorting MPI critical path segments...0.000 sec
    Aggregating samples...0.000 sec
    ...
    ...
    ...
    Raw collection data is stored in /tmp/.devkit_3b9014edeb20b0ed674a9121f1996fb0/TMP_HPCTOOL_DATA/my_raw_data.v1_19.mpirun-3204841473
    Issue#1: High CPI value (0.67), ideal value is 0.25. It indicates non-efficient
    CPU MicroArchitecture usage. Possible solutions:
    Issue#1: High CPI value (0.67), ideal value is 0.25. It indicates non-efficient
    CPU MicroArchitecture usage. Possible solutions:
    1. Top-down  MicroArchitecture  tree  shows  high value of BackEnd Bound/Core
        Bound metric (0.62).
    Issue#2: CPU  under-utilization  -  inappropriate  amount  of  ranks.  Possible
    solutions:
    1. Consider  increasing total amount of MPI ranks from 10 to 128 using mpirun
        -n  option,  or  try  to  parallelize code with both MPI and OpenMP so the
        number  of  processes(ranks  * OMP_NUM_THREADS) will be equal to CPUs(128)
        count.
    Issue#3: High  Inter Socket Bandwidth value (5.82 GB/s). Average DRAM Bandwidth
    is 46.25 GB/s. Possible solutions:
    1. Consider   allocating   memory   on   the  same  NUMA  node  it  is  used.
    HINT:  Consider  re-running  collection  with  -l  detail  option  to  get more
    information about microarchitecture related issues.
    The report /home/hpc-perf/hpc-perf-20240314-110009.tar is generated successfully
    To view the summary report，you can run: devkit report -i /home/hpc-perf/hpc-perf-20240314-110009.tar
    To view the detail  report，you can import the report to WebUI or IDE
    [Rank000][localhost.localdomain] =====================================RESTORE CLUSTER=====================================
    [Rank000][localhost.localdomain] restore cluster success.
    [Rank000][localhost.localdomain] =========================================FINISH =========================================
    ```

- 任务类型为detail（普通） 

    命令：

    ```shell
    /opt/ompi/bin/mpirun --allow-run-as-root -H 1.2.3.4:1  devkit tuner hpc-perf -L detail -o /home/hpc-perf-detail.tar -l 0 -d 20 -D 15 /opt/test/testdemo/ring
    ```

    >[说明]
    >
    >-o参数指定生成报告压缩包路径，-l参数指定日志等级，0表示为debug，-d 20表明应用会运行20秒进行数据采集，-D 15表示延迟15秒再进行采集（即应用运行15秒后开始采集）。
    >
    >上述参数支持所有等级任务采集。

- 任务类型为detail（多参数）

    ```shell
    /opt/ompi/bin/mpirun --allow-run-as-root -H 1.2.3.4:1 devkit tuner hpc-perf -L detail -o /home/hpc-perf-detail.tar -l 0 -d 20 -D 15 --mpi-only --critical-path /opt/test/testdemo/ring
    ```

    >[说明]
    >
    >--mpi-only可减少OMP的采集分析，提高性能， --critical-path采集关键路径信息。
    >
    >上述参数支持summary和detail等级任务采集。

- 任务类型为graphic，采集通信热力图信息。

    命令：

    ```shell
    /opt/ompi/bin/mpirun --allow-run-as-root -H 1.2.3.4:1  devkit tuner hpc-perf -L graphic -d 300 --call-stack --rank-fuzzy 128 --region-max 1000 --rdma-collect 1 --shared-storage 1 /opt/test/testdemo/ring
    ```

    >[说明]
    >
    >--call-stack采集call stack数据， --rank-fuzzy调整热力图模糊化倍率， --region-max调整时序图region数量，--rdma-collect 1为一秒采集一次RDMA数据，--shared-storage 1为一秒采集一次共享存储数据。
    >
    >上述参数支持graphic等级任务采集。

    结果回显

    ```shell
    [Rank000][localhost.localdomain] =======================================PARAM CHECK=======================================
    [Rank000][localhost.localdomain] PARAM CHECK success.
    [Rank000][localhost.localdomain] ===================================PREPARE FOR COLLECT===================================
    [Rank000][localhost.localdomain] preparation of collection success.
    [Rank000][localhost.localdomain] ==================================COLLECT AND ANALYSIS ==================================
    loop time :2
    send message from rank 4 to rank 9
    send message from rank 4 to rank 9
    loop time :2
    ...
    ...
    ...
    send message from rank 5 to rank 0
    Time measured: 0.310607 seconds.
    barrier rank 8
    send message from rank 8 to rank 3
    Time measured: 0.310637 seconds.
    Finish collection.Progress 100%.
    Postprocessing OTF2 trace(s)...
    Successful
    OTF2 traces are stored in /tmp/.devkit_1d8ffdfa224a7372beceb19b52a8c510/TMP_HPCTOOL_DATA/my_result.v1_19.rank*.otf2
    Raw collection data is stored in /tmp/.devkit_1d8ffdfa224a7372beceb19b52a8c510/TMP_HPCTOOL_DATA/my_raw_data.v1_19.mpirun-2708930561
    4 region has been processed, cost time 0.19 s.
    The report /home/hpc-perf/hpc-perf-20240314-110450.tar is generated successfully
    To view the detail report, you can import the report to the WebUI or IDE
    [Rank000][localhost.localdomain] =====================================RESTORE CLUSTER=====================================
    [Rank000][localhost.localdomain] restore cluster success.
    [Rank000][localhost.localdomain] =========================================FINISH =========================================
    ```

- 使用report功能查看任务报告。 

    命令：

    ```shell
    devkit report -i hpc-perf-xxxxxxx-xxxxxxx.tar
    ```

    结果回显

    ```shell
    Elapsed Time                          :               0.3161 s (rank 000, jitter = 0.0002s)
    CPU Utilization                       :                 7.64 % (9.78 out of 128 CPUs)
    Effective Utilization               :                 7.64 % (9.78 out of 128 CPUs)
    Spinning                            :                 0.00 % (0.00 out of 128 CPUs)
    Overhead                            :                 0.00 % (0.00 out of 128 CPUs)
    Cycles per Instruction (CPI)        :               0.6718
    Instructions Retired                :          11961967858
    MPI
    ===
    MPI Wait Rate                       :                 0.20 %
        Imbalance Rate                    :                 0.14 %
        Transfer Rate                     :                 0.06 %
        Top Waiting MPI calls
        Function     Caller location                         Wait(%)  Imb(%)  Transfer(%)
        ---------------------------------------------------------------------------------
        MPI_Barrier  main@test_time_loop.c:72                   0.17    0.13         0.03
        MPI_Recv     first_communicate@test_time_loop.c:17      0.02    0.01         0.01
        MPI_Send     first_communicate@test_time_loop.c:14      0.01       0         0.01
        MPI_Send     second_communicate@test_time_loop.c:31     0.00       0         0.00
        MPI_Recv     second_communicate@test_time_loop.c:28     0.00    0.00         0.00
    Top Hotspots on MPI Critical Path
    Function      Module     CPU Time(s)  Inst Retired     CPI
    ----------------------------------------------------------
    do_n_multpli  test_loop       0.3101    1189348874  0.6780
    Top MPI Critical Path Segments
    MPI Critical Path segment                                        Elapsed Time(s)  CPU Time(s)  Inst Retired     CPI
    -------------------------------------------------------------------------------------------------------------------
    MPI_Send@test_time_loop.c:14 to MPI_Barrier@test_time_loop.c:72           0.3158       0.3101    1189348874  0.6780
    MPI_Send@test_time_loop.c:14 to MPI_Send@test_time_loop.c:14              0.0000
    Instruction Mix
    ===============
    Memory                              :                58.20 %
    Integer                             :                25.11 %
    Floating Point                      :                 0.00 %
    Advanced SIMD                       :                 0.00 %
    Not Retired                         :                 0.00 %
    Top-down
    ========
    Retiring                            :                37.21 %
    Backend Bound                       :                62.85 %
        Memory Bound                      :                 0.56 %
        L1 Bound                        :                 0.55 %
        L2 Bound                        : value is out of range likely because of not enough samples collected
        L3 or DRAM Bound                :                 0.01 %
        Store Bound                     :                 0.00 %
        Core Bound                        :                62.30 %
    Frontend Bound                      :                 0.02 %
    Bad Speculation                     :                 0.00 %
    Memory subsystem
    ================
    Average DRAM Bandwidth              :              46.2486 GB/s
        Read                              :              30.5352 GB/s
        Write                             :              15.7134 GB/s
    L3 By-Pass ratio                    :                20.23 %
    L3 miss ratio                       :                59.96 %
    L3 Utilization Efficiency           :                54.90 %
    Within Socket Bandwidth             :               3.8750 GB/s
    Inter Socket Bandwidth              :               5.8249 GB/s
    ```

- 输出说明
  1. detail和summary类型任务，可使用report查看结果。
  2. graphic类型的任务，可在Web导入查看图形化结果。
  3. report功能查看的HPC指标详情可参考Web界面参数说明。

## 6.4 NUMA精细化分析

### 命令功能
基于ARM SPE的能力分析得到系统精细化的DDR访问、NUMA访问流量矩阵以及进程的内存访问等信息。
```text
[说明]
- 采集NUMA精细化数据时需要服务器支持ARM SPE采集能力，配置SPE请参见配置SPE环境。
- 已生成TAR包的任务可导入Web界面进行图形可视化的查看。导入详情请参见任务管理中的任务导入部分内容。
```

### 命令格式
```shell
devkit tuner numafast [-d <DURATION> | --duration=DURATION] [-i <INTERVAL>] | --interval=INTERVAL]
```

### 参数说明
**表1 参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>file</td>
    <td>
      设置报告数据文件名，不设置时默认在当前所在路径生成numafast-xxxx-xxxx.tar。<br>
      指定名称时，例如/opt/report1, 则在/opt下生成report1.tar，若存在同名文件，则生成report1-xxxx-xxxx.tar。
    </td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      配置日志等级。默认值为1(info)。<br>
      - 0（debug）<br>
      - 1（info）<br>
      - 2（warning）<br>
      - 3（error）
    </td>
  </tr>
  <tr>
    <td>-d/--duration</td>
    <td>Num</td>
    <td>
      设置采集时长，单位为秒，不设置时默认为一直采集。<br>
      可使用Ctrl+\取消任务或Ctrl+C组合键停止采集并进入分析。
    </td>
  </tr>
  <tr>
    <td>-i/--interval</td>
    <td>Num</td>
    <td>
      设置采样间隔，不设置时默认为5秒。
    </td>
  </tr>
  <tr>
    <td>-c/--count</td>
    <td>Num</td>
    <td>
      设置SPE采集指令间隔，可设置1到4,294,967,295个。<br>
      不设置时默认为2048。
    </td>
  </tr>
  <tr>
    <td>-n/--num</td>
    <td>Num</td>
    <td>
      设置需要展示的topN的进程数。<br>
      默认为10个。
    </td>
  </tr>
  <tr>
    <td>-t/--threads</td>
    <td>Num</td>
    <td>
      设置需要展示的topN的线程数。<br>
      参数选项为可选，默认为5个。
    </td>
  </tr>
  <tr>
    <td>--package</td>
    <td>--</td>
    <td>
      该参数指定情况下才会落盘生成tar包报告。
    </td>
  </tr>
  <tr>
    <td>-f/--file</td>
    <td>--</td>
    <td>
      设置仅生成报告文件而不将报告数据生成压缩包。该参数需和--package配合使用。
    </td>
  </tr>
</table>


### 使用示例
命令：
```shell
devkit tuner numafast -i 2 -c 2048 -n 3 -t --package
```
```text
[说明]
- 该命令采集参数为采样间隔2秒，SPE采集指令间隔为2048个，展示Top3的进程数，并生成报告数据压缩包到默认路径。
- 不设置-d参数时可使用Ctrl+\取消任务或Ctrl+C组合键停止采集；若使用-d参数，输出报告数受-i参数影响，例：-d 10 -i 2（采样时长10秒，采样间隔2秒，则生成报告数为5份）。
- 设置-t参数则增加显示线程数据，-t参数为可选参数，无参数则显示top5线程数
```
结果回显
```shell
Enter analyze mode, please wait 2 seconds...

NUMAFAST ANALYSIS(Press Ctrl+C to exit)
==========================================================================================
1. System's numa score : 0.50
   Note:
         score = (max cost - real cost) / (max cost - min cost)
         real cost = SUM(numa distance(i, j) * access percentage(i, j)), 0<=i,j<node number
         max cost = MAX(numa distance) , min cost = MIN(numa distance).
         This score is best at 1 and worst at 0.
         Format: traffic | numa distance | access percentage.

              DST_0               DST_1               DST_2               DST_3
SRC_0   0.14GB|10|30.30%    0.01GB|12|1.39%     0.00GB|20|0.00%     0.00GB|22|0.00%
SRC_1   0.00GB|12|0.00%     0.00GB|10|1.07%     0.00GB|22|0.00%     0.00GB|24|0.00%
SRC_2   0.14GB|20|30.30%    0.00GB|22|0.21%     0.00GB|10|0.00%     0.00GB|12|0.00%
SRC_3   0.14GB|22|30.30%    0.01GB|24|2.50%     0.00GB|12|0.00%     0.02GB|10|3.95%

==========================================================================================
2. Node detail information of memory access traffic:
   Note:
         RMA(Die): Access traffic across NUMA dies.
         RMA(Socket): Access traffic across NUMA sockets.
         LMA: Local access traffic on the NUMA node.
         %CPU: Number of occupied CPU cores. For example, 600% indicates that 6 CPU cores
         are occupied.

 NID  RMA_Die  RMA_Skt      LMA    %RMA   MEM_all  MEM_free   %MEM      %CPU
   0   0.01GB   0.00GB   0.14GB    4.37   63.21GB   55.82GB  11.69     23.93
   1   0.00GB   0.00GB   0.00GB    0.00   63.93GB   62.70GB   1.92      0.37
   2   0.00GB   0.14GB   0.00GB  100.00   63.93GB   62.96GB   1.52      0.00
   3   0.00GB   0.15GB   0.02GB   89.26   62.93GB   56.56GB  10.13      0.00

==========================================================================================
3. Show top 3 processes and top 5 threads which sorted by memory access:
   Note:
         If the collected processes less than the number specified by -n (--num), only
         the actual processes are displayed.
         ACCESS: Percentage of the process access traffic to the total traffic. Top N
         sorting is based on this. Threads are the same.
         MIGRATED X|Y: X indicates how many times threads of the process are migrated between
         NUMA nodes, and Y indicates the number of threads in the process.
         %CPU: The meaning is the same as that of the node data, but the data of the first
         report is not included.

 PID(TID)  SCORE  ACCESS  RMA_Die  RMA_Skt      LMA    %RMA  MIGRATED    %CPU    COMMAND
   4279     0.21  61.44%   0.00GB   0.28GB   0.00GB  100.00    0|5        --     dockerd
├─  10811   0.28  30.46%   0.00GB   0.14GB   0.00GB  100.00    -|-        --     dockerd
├─   4488   0.14  30.40%   0.00GB   0.14GB   0.00GB  100.00    -|-        --     dockerd
├─   9965   0.00   0.48%   0.00GB   0.00GB   0.00GB  100.00    -|-        --     dockerd
├─   4489   0.00   0.05%   0.00GB   0.00GB   0.00GB  100.00    -|-        --     dockerd
└─  10158   0.00   0.05%   0.00GB   0.00GB   0.00GB  100.00    -|-        --     dockerd

1582943     1.00  30.30%   0.00GB   0.00GB   0.14GB    0.00    0|1        --     main_tuner
└─1582943   1.00  30.30%   0.00GB   0.00GB   0.14GB    0.00    -|-        --     main_tuner

   4618     0.52   4.26%   0.01GB   0.01GB   0.00GB   76.25    0|8        --     containerd
├─  10183   0.00   0.85%   0.00GB   0.00GB   0.00GB  100.00    -|-        --     containerd
├─ 283527   0.86   0.75%   0.00GB   0.00GB   0.00GB  100.00    -|-        --     containerd
├─  10151   0.86   0.64%   0.00GB   0.00GB   0.00GB  100.00    -|-        --     containerd
├─  10532   0.00   0.59%   0.00GB   0.00GB   0.00GB  100.00    -|-        --     containerd
└─   4848   1.00   0.53%   0.00GB   0.00GB   0.00GB    0.00    -|-        --     containerd

==========================================================================================
The report /home/numafast/numafast-20241121-094906.tar is generated successfully
To view the summary report, you can run: devkit report -i /home/numafast/numafast-20241121-094906.tar
To view the detail report, you can import the report to WebUI or IDE
```

- 输出报告说明

  报告由三部分组成，分别为访存矩阵信息，内存访问流量的节点详细信息和按内存访问排序的进程信息。

  1.访存矩阵每个数据有三个组成，分别为SRC到DST的带宽流量，SRC到DST的NUMA切换次数，该SRC到DST的流量在总流量的占比。

  2.内存访问流量的节点详细信息
  
  **表2 输出报告说明**
    <table>
      <tr>
        <th>参数</th>
        <th>说明</th>
      </tr>
      <tr>
        <td>NID</td>
        <td>NUMA的ID。</td>
      </tr>
      <tr>
        <td>RMA(Die)</td>
        <td>跨NUMA的访问流量。</td>
      </tr>
      <tr>
        <td>RMA(Skt)</td>
        <td>跨NUMA套接字访问流量。</td>
      </tr>
      <tr>
        <td>LMA</td>
        <td>NUMA节点上的本地访问流量。</td>
      </tr>
      <tr>
        <td>%RMA</td>
        <td>远端访问流量占比。</td>
      </tr>
      <tr>
        <td>MEM(all)</td>
        <td>总内存大小。</td>
      </tr>      
      <tr>
        <td>MEM(free)</td>
        <td>可使用内存的大小。</td>
      </tr>
      <tr>
        <td>%MEM</td>
        <td>内存使用率。</td>
      </tr>
      <tr>
        <td>%CPU</td>
        <td>CPU使用率，以单个核做为分母，如600%表示占满6个CPU核。</td>
      </tr>
    </table>

  2.显示按内存访问排序的前几个进程信息

  **表3 输出报告说明**
    <table>
      <tr>
        <th>参数</th>
        <th>说明</th>
      </tr>
      <tr>
        <td>PID</td>
        <td>进程ID。</td>
      </tr>
      <tr>
        <td>SCORE</td>
        <td>NUMA情况评分。</td>
      </tr>
      <tr>
        <td>ACCESS</td>
        <td>进程访问流量占总流量的百分比，Top N的排序就是以此为基础的。</td>
      </tr>
      <tr>
        <td>RMA(Die)</td>
        <td>跨NUMA的访问流量。</td>
      </tr>
      <tr>
        <td>RMA(Skt)</td>
        <td>跨NUMA套接字访问流量。</td>
      </tr>
      <tr>
        <td>LMA</td>
        <td>NUMA节点上的本地访问流量。</td>
      </tr>
      <tr>
        <td>%RMA</td>
        <td>远端访问流量占比。</td>
      </tr>
      <tr>
        <td>MIGRATED</td>
        <td>线程在不同NUMA节点的迁移次数和进程的线程数。</td>
      </tr>
      <tr>
        <td>%CPU</td>
        <td>CPU使用率，以单个核做为分母，如600%表示占满6个CPU核。</td>
      </tr>
      <tr>
        <td>COMMAND</td>
        <td>进程的命令行。</td>
      </tr>
    </table>

## 6.5 Roofline分析

### 命令功能
Roofline分析可帮助用户在给定硬件平台上，分析出应用程序的瓶颈点位置，从而有针对性的进行优化。
```text
[说明]
- 仅支持基于鲲鹏920的服务器；且不支持容器环境。
- Roofline使用DBI技术，待分析的应用必须为ELF格式的二进制文件。
- Roofline采集时需确保应用已完成运行；Roofline采集时长大概为应用运行时长三倍。
```

### 命令格式
```shell
devkit tuner roofline [-h] [-l {0,1,2,3}] [-m {total,region}] [-o <file>] [--hbm-mode {cache,flat}] workload [workload ...]
```

### 参数说明
**表1 参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0/1/2/3</td>
    <td>
      配置日志等级。默认值为2(warning)。<br>
      - 0（debug）<br>
      - 1（info）<br>
      - 2（warning）<br>
      - 3（error）
    </td>
  </tr>
  <tr>
    <td>-m/--mode</td>
    <td>total/region</td>
    <td>
      配置分析范围为整改二进制应用或用户选择的regions；默认为total。<br>
      - total模式：采集整个应用的roofline数据。<br>
      - region模式：采集应用中各个region的roofline数据，程序的region划分需要用户按需进行插桩。
    </td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>file</td>
    <td>
      设置报告数据文件名，不设置时默认在当前所在路径生成roofline-xxxx-xxxx.tar。<br>
      指定名称时，例如/opt/report1, 则在/opt下生成report1.tar，若存在同名文件，则生成report1-xxxx-xxxx.tar。
    </td>
  </tr>
    <tr>
    <td>-hbm-mode</td>
    <td>cache/flat</td>
    <td>
      配置采集HBM数据的模式；若环境不支持HBM，使用此参数不采集HBM数据。
      <br>
      - cache：采集L1数据、L2数据、HBM数据和DDR数据。
<br>
      - flat：采集L1数据、L2数据、HBM和DDR的混合数据（采集的HBM会和原有DDR混合在一起）。
    </td>
  </tr>
</table>


### 使用示例
采集已划分好region的应用：
```shell
devkit tuner roofline -m region /mysharedir/devkit/SystemProfilerBackend/tuner_cli/docs/matrix_multiply_c
```
任务回显
```shell
Note:
  1. Roofline task is currently only supported on the 920 platform.
  2. The application must be a binary file in ELF format.
  3. Roofline task collection needs to ensure the application has finished running.
  4. The estimated time of roofline collection is about 3 * application estimated time.
  5. You can learn about the roofline profiling method by looking at document /usr/local/devkit/tuner/docs/ROOFLINE_KNOW_HOW.MD
RFCOLLECT: Start collection for /mysharedir/devkit/SystemProfilerBackend/tuner_cli/docs/matrix_multiply_c
RFCOLLECT: Launch application to collect performance metrics of /mysharedir/devkit/SystemProfilerBackend/tuner_cli/docs/matrix_multiply_c
ROOFLINE_EVENTS are initialized.
Initialization time: 0.070167 seconds
Calculation time: 0.206211 seconds
The dimension of the matrices is too large to print.
RFCOLLECT: Launch application to do binary instrumentation of /mysharedir/devkit/SystemProfilerBackend/tuner_cli/docs/matrix_multiply_c
Initialization time: 0.168616 seconds
Calculation time: 2.243492 seconds
The dimension of the matrices is too large to print.
RFCOLLECT: Launch benchmarks for measuring roofs
RFCOLLECT: Processing all collected data
RFCOLLECT: Result is captured at /mysharedir/devkit/SystemProfilerBackend/sys_perf/components/sys_tools/rfcollect-20240424-143840.json
RFCOLLECT: Run "rfreport /mysharedir/devkit/SystemProfilerBackend/sys_perf/components/sys_tools/rfcollect-20240424-143840.json" to get report.
Get roofline report ...
The roofline json report: /mysharedir/devkit/SystemProfilerBackend/sys_perf/components/sys_tools/roofline-20240424-143840.json
The roofline html report: /mysharedir/devkit/SystemProfilerBackend/sys_perf/components/sys_tools/roofline-20240424-143840.html
```

- 任务将生成json文件和html文件，如需进行数据分析可直接使用json文件；查看性能数据可在浏览器中打开html文件。
- 需要了解解报告的解读，可以查看Note中第5点查看Know-How文档。


## 6.6 热点函数分析

### 命令功能
支持分析C/C++程序代码识别性能瓶颈，给出对应的Top热点函数和调用栈详情，通过火焰图展示函数的调用关系，发现优化路径。同时该功能会采集程序在各个CPU核上运行时的CPU频率变化，提供波动较大的CPU频率信息以供用户进一步优化。

### 命令格式
```shell
devkit tuner hotspot [-h] [-c {0 | 0,1,2 | 0-2}] [-r {user, kernel, all}] [-d <sec>] [-D <sec>] [-t n] [-f n] [-l {0, 1, 2, 3}] [-i <sec>] [-e] [-o] [-s] [-p {PID1 | PID1,PID2 | ALL}] [-g] [--package] [--long-name] [--dwarf] [workload workload...]
```
### 参数说明
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-c/--cpu</td>
    <td>core_num</td>
    <td>仅支持在CPU列表中的采样。可以输入以逗号分隔且没有空格的多个CPU，例如：0,1。也可以使用'-'来指定CPU采样的范围，例如：0-2。如果同时输入-c和-p参数，会优先以-p模式进行采集。</td>
  </tr>
  <tr>
    <td>-d/--duration</td>
    <td>Num</td>
    <td>设置采集时长，最小值为1，不设置时默认为一直采集，可使用Ctrl+\取消任务或Ctrl+C停止采集并进入分析。</td>
  </tr>
  <tr>
    <td>-D/--delay</td>
    <td>Num</td>
    <td>适用于应用程序启动后需要等待一段时间再开始采集的场景，不指定时默认值为0。</td>
  </tr>
  <tr>
    <td>-t/--top</td>
    <td>Num</td>
    <td>指定结果报告中需要展示的函数个数，最小值为1，默认展示所有占比大于0.01%的函数。</td>
  </tr>
  <tr>
    <td>-i/--interval</td>
    <td>Num</td>
    <td>设置采样间隔（以秒为单位）。最小值为1秒，最大值不能超过采集时长。默认为持续时间。如果不指定间隔，不生成子报告。每个子报告中收集数据的时间取决于间隔参数。</td>
  </tr>
  <tr>
    <td>-e/--event</td>
    <td>event_name</td>
    <td>指定采集分析的事件名，仅可指定一个，默认为'cycles'。可以通过'devkit tuner hotspot list'查看当前环境支持的事件列表。</td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0/1/2/3</td>
    <td>
        配置日志等级。默认值为1(info)。<br>
        - 0（debug）<br>
        - 1（info）<br>
        - 2（warning）<br>
        - 3（error）
    </td>
  </tr>
  <tr>
    <td>-f/--frequency</td>
    <td>Num</td>
    <td>设置采样频率，最小值为1，默认为200。</td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>file</td>
    <td>设置报告数据生成文件名，不需要以".tar"结尾。</td>
  </tr>
  <tr>
    <td>-r/--clloection-range</td>
    <td>user/kernel/all</td>
    <td>
        设置采集模式，不指定时默认为all。
        all：采集用户态和内核态的性能数据。
        user：采集用户态的性能数据。kernel：采集内核态的性能数据。
    </td>
  </tr>
  <tr>
    <td>-s/--src-dir</td>
    <td>dir</td>
    <td>
        指定源码工程目录，用于查找并关联源码。
    </td>
  </tr>
  <tr>
    <td>-g</td>
    <td>--</td>
    <td>设置是否显示调用堆栈信息。如果启用-g选项，将生成火焰图html文件。</td>
  </tr>
  <tr>
    <td>-p/--pid</td>
    <td>PID</td>
    <td>
      指定采集的进程PID，多个进程PID可用“,”分隔。若同时使用-p和-c参数则优先采集指定PID的进程，若不指定默认采集全部进程。
    </td>
  </tr>
  <tr>
    <td>--long-name</td>
    <td>--</td>
    <td>
      设置是否显示详细函数和模块信息。
    </td>
  </tr>
  <tr>
    <td>--dwarf</td>
    <td>--</td>
    <td>
      设置是否关联 C/C++ 的源代码文件。
    </td>
  </tr>
  <tr>
    <td>--package</td>
    <td>--</td>
    <td>
      设置是否将数据导入到数据库中，并在输出路径下生成tar包。可以使用devkit命令行查看此包，也可以将其导入web gui进行查看。
    </td>
  </tr>
</table>

### 使用示例
针对cpu进行采集（仅CPU110的CPU频率在采集过程中波动较大）：
```shell
devkit tuner hotspot -c 110-112 -d 10 -r user
```
返回信息如下：
```shell

Hotspot Summary Report-ALL                              Time:2025/05/21 17:24:11
================================================================================

1.The current server supports a maximum of 2600 MHz CPU frequency and a minimum of 200 MHz.
2.Only the collected CPU frequency information about the running process is displayed. Considering the large number of cores, only the CPU frequency with a difference of more than 1% from the maximum CPU frequency is displayed.
For example, the collected process runs on CPUs 0-10, and only the difference between the CPU frequency of CPUs 3-6 and the maximum frequency supported by the current server exceeds 1%. In this case, CPU 3-6 is displayed.
─────────────────────────────────────────────────────────────────────────────
  Core       Avg Frequency(MHz)    Max Frequency(MHz)    Min Frequency(MHz)
─────────────────────────────────────────────────────────────────────────────
  CPU110                   1135                  1211                   896
─────────────────────────────────────────────────────────────────────────────

────────────────────────────────────────────────────────────────────────────────────────────────
  Function                                  cycles    Module                         cycles(%)
────────────────────────────────────────────────────────────────────────────────────────────────
  Hotspot::Mon***riable(int)            28,295,946    libtuner.so                        13.19
  KUNPENG_SYM:***har const*)            23,937,102    libsym.so                          11.16
  _pthread_cle***_push_defer            22,824,809    libpthread-2.28.so                 10.64
  el0_svc_common                        20,437,520    [kernel]                            9.53
  0x79b84                               17,734,958    libc-2.28.so                        8.27
  runtime.(*lfstack).push               17,149,776    dockerd                             7.99
  0x78e34                               16,163,183    libc-2.28.so                        7.53
  0xa2a9c                               15,726,617    libglib-2.0.so.0.6600.8             7.33
  _PyType_Lookup                        14,070,497    libpython3.9.so.1.0                 6.56
  std::_Rb_tre***node_base&)            10,375,159    libstdc++.so.6.0.24                 4.84
  __libc_malloc                         10,287,180    libc-2.28.so                        4.79
  0x260ec                                9,941,742    libsym.so                           4.63
  0x25f9c                                6,144,404    libsym.so                           2.86
  runtime.runqgrab                         320,367    dockerd                             0.15
  runtime.greyobject                       187,025    dockerd                             0.09
  runtime.scanobject                       156,426    dockerd                             0.07
  runtime.notesleep                        118,716    dockerd                             0.06
  runtime.findrunnable                      88,611    dockerd                             0.04
  index                                     76,937    libc-2.28.so                        0.04
  g_closure_ref                             69,065    libgobject-2.0.so.0.6600.8          0.03
  0x70c46c                                  62,180    magent                              0.03
  safe_close                                61,249    libsystemd-shared-243.so            0.03
  0x10540                                   60,090    auditd                              0.03
  fjson_object_put                          59,935    libfastjson.so.4.3.0                0.03
  0x5be40                                   51,490    python3.9                           0.02
  0x11850                                   49,759    libsystemd.so.0.27.0                0.02
  0x6a1c4                                   43,487    libpython3.9.so.1.0                 0.02
  _PyEval_EvalFrameDefault                  38,232    python3.9                           0.02
  PyBuffer_Release                          12,399    python3.9                           0.01
────────────────────────────────────────────────────────────────────────────────────────────────
5080 milliseconds time elapsed

If *** is displayed in Function, use --long-name to show full function name.
```
- 该命令将限定采集110，111，112三个CPU核上的数据，且只采集用户态的数据，采样时长指定为10秒。只有CPU110、111、112的CPU频率会被筛选，并展示波动超过当前支持最大频率1%的CPU频率数据，用户可针对降频较多的CPU核进行进一步定位优化。

<br>
针对pid进行采集（开启调用栈，采集cache-misses事件）：
```shell
devkit tuner hotspot -d 10 -e cache-misses -p 1929984,1930038 -g
```

返回信息如下：
```shell

Hotspot Summary Report-ALL                              Time:2025/05/21 17:32:21
================================================================================

1.The current server supports a maximum of 2600 MHz CPU frequency and a minimum of 200 MHz.
2.Only the collected CPU frequency information about the running process is displayed. Considering the large number of cores, only the CPU frequency with a difference of more than 1% from the maximum CPU frequency is displayed.
For example, the collected process runs on CPUs 0-10, and only the difference between the CPU frequency of CPUs 3-6 and the maximum frequency supported by the current server exceeds 1%. In this case, CPU 3-6 is displayed.
─────────────────────────────────────────────────────────────────────────────
  Core       Avg Frequency(MHz)    Max Frequency(MHz)    Min Frequency(MHz)
─────────────────────────────────────────────────────────────────────────────
  CPU110                   1047                  1198                   965
─────────────────────────────────────────────────────────────────────────────

────────────────────────────────────────────────────────────────────────────────────────────────
  Function                            cache-misses    Module                   cache-misses(%)
────────────────────────────────────────────────────────────────────────────────────────────────
  inc_b                             26,021,366,230    falsesharinglong                   33.53
  sum_a                             25,795,933,126    falsesharinglong                   33.24
  functest()                        19,793,264,688    mul_use                            25.51
  func3_2_1()                        2,845,853,684    mul_use                             3.67
  main                               1,917,929,698    mul_use                             2.47
  func3_1()                          1,223,042,183    mul_use                             1.58
────────────────────────────────────────────────────────────────────────────────────────────────
10031 milliseconds time elapsed

If *** is displayed in Function, use --long-name to show full function name.
Callstack is saved to /opt/testdemo/callstack-20240605-173221.log
Flamegraph is saved to /opt/testdemo/Flamegraph-20240605-173221.html

```
- 该命令将采集pid为1929984,1930038的进程信息，并且开启调用栈采集，可在结束采集后通过callstack文件查看各个函数的调用栈详情，或通过Flamegraph文件查看火焰图。同时在pid为1929984,1930038的进程所运行的CPU核上筛选出波动超过当前支持最大频率1%的CPU频率数据进行展示，用户可针对降频较多的CPU核进行进一步定位优化。

<br>
查看当前环境可支持的采集事件列表：
```shell
devkit tuner hotspot list
```

返回信息如下：
```shell

List of pre-defined events (to be used in -e):

  hit_on_prf                                         [Core event]
  prf_req                                            [Core event]
  if_is_stall                                        [Core event]
  exe_stall_cycle                                    [Core event]
  iq_is_empty                                        [Core event]
  fetch_bubble                                       [Core event]
  l2d_cache_wb_victim                                [Core event]
  l2d_cache_wr                                       [Core event]
  l1d_tlb_wr                                         [Core event]
  l1d_tlb_rd                                         [Core event]
  l1d_tlb_refill_wr                                  [Core event]
  l1d_cache_inval                                    [Core event]
  l1d_cache_refill_rd                                [Core event]
  mem_stall_l2miss                                   [Core event]
  l1d_cache_wr                                       [Core event]
  iTLB-loads                                         [Core event]
  iTLB-load-misses                                   [Core event]
  dTLB-loads                                         [Core event]
  l1d_cache_wb_victim                                [Core event]
  dTLB-load-misses                                   [Core event]
  branch-loads                                       [Core event]
  l1d_cache_wb_clean                                 [Core event]
  L1-icache-loads                                    [Core event]
  idle-cycles-frontend                               [Core event]
  L1-icache-load-misses                              [Core event]
  mem_stall_l1miss                                   [Core event]
  l1i_cache_prf_refill                               [Core event]
  l1d_cache_rd                                       [Core event]
  branch-load-misses                                 [Core event]
  idle-cycles-backend                                [Core event]
  L1-dcache-stores                                   [Core event]
  L1-dcache-loads                                    [Core event]
  l2d_cache_wb_clean                                 [Core event]
  L1-dcache-load-misses                              [Core event]
  stalled-cycles-frontend                            [Core event]
  stalled-cycles-backend                             [Core event]
  l2d_cache_inval                                    [Core event]
  instructions                                       [Core event]
  mem_stall_anyload                                  [Core event]
  cycles                                             [Core event]
  l1d_tlb_refill_rd                                  [Core event]
  L1-dcache-store-misses                             [Core event]
  cpu-cycles                                         [Core event]
  cache-references                                   [Core event]
  l2d_cache_rd                                       [Core event]
  cache-misses                                       [Core event]
  l1i_cache_prf                                      [Core event]
  bus-cycles                                         [Core event]
  l2d_cache_refill_rd                                [Core event]
  branch-misses                                      [Core event]
  br_retired                                         [Core event]
  l2i_cache_refill                                   [Core event]
  l1d_cache_refill                                   [Core event]
  cid_write_retired                                  [Core event]
  ll_cache_miss_rd                                   [Core event]
  inst_spec                                          [Core event]
  sw_incr                                            [Core event]
  l1d_tlb_refill                                     [Core event]
  stall_frontend                                     [Core event]
  sample_filtrate                                    [Core event]
  l1i_tlb_refill                                     [Core event]
  br_mis_pred                                        [Core event]
  ll_cache_rd                                        [Core event]
  bus_access                                         [Core event]
  mem_access                                         [Core event]
  br_pred                                            [Core event]
  l2d_tlb                                            [Core event]
  l1d_cache                                          [Core event]
  ll_cache_miss                                      [Core event]
  l2d_cache                                          [Core event]
  inst_retired                                       [Core event]
  remote_access                                      [Core event]
  bus_cycles                                         [Core event]
  itlb_walk                                          [Core event]
  l2d_cache_refill                                   [Core event]
  exc_return                                         [Core event]
  l1d_tlb                                            [Core event]
  remote_access_rd                                   [Core event]
  sample_collision                                   [Core event]
  l1d_cache_wb                                       [Core event]
  l1i_cache_refill                                   [Core event]
  l2d_tlb_refill                                     [Core event]
  l2i_tlb_refill                                     [Core event]
  dtlb_walk                                          [Core event]
  br_mis_pred_retired                                [Core event]
  l2i_tlb                                            [Core event]
  l1i_cache                                          [Core event]
  stall_backend                                      [Core event]
  memory_error                                       [Core event]
  l2i_cache                                          [Core event]
  l1i_tlb                                            [Core event]
  ll_cache                                           [Core event]
  ttbr_write_retired                                 [Core event]
  sample_feed                                        [Core event]
  cpu_cycles                                         [Core event]
  exc_taken                                          [Core event]
  br_return_retired                                  [Core event]
  l2d_cache_wb                                       [Core event]
  sample_pop                                         [Core event]

  You can also use raw event to collect data, for example, 'devkit tuner hotspot -e r0011'

```
<br>

针对应用进行采集：
```shell
devkit tuner hotspot -d 10 -D 1 -g --package -o /home/sysbench_data sysbench cpu --threads=4 run
```
返回信息如下：
```shell
sysbench 1.0.14 (using bundled LuaJIT 2.1.0-beta2)

Running the test with following options:
Number of threads: 4
Initializing random number generator from current time


Prime numbers limit: 10000

Initializing worker threads...

Threads started!

CPU speed:
    events per second: 13451.03

General statistics:
    total time:                          10.0003s
    total number of events:              134530

Latency (ms):
         min:                                    0.30
         avg:                                    0.30
         max:                                    0.43
         95th percentile:                        0.30
         sum:                                39938.97

Threads fairness:
    events (avg/stddev):           33632.5000/6.10
    execution time (avg/stddev):   9.9847/0.00


Hotspot Summary Report-ALL                              Time:2025/05/21 10:13:21
================================================================================

1.The current server supports a maximum of 2600 MHz CPU frequency and a minimum of 200 MHz.
2.Only the collected CPU frequency information about the running process is displayed. Considering the large number of cores, only the CPU frequency with a difference of more than 1% from the maximum CPU frequency is displayed.
For example, the collected process runs on CPUs 0-10, and only the difference between the CPU frequency of CPUs 3-6 and the maximum frequency supported by the current server exceeds 1%. In this case, CPU 3-6 is displayed.
───────────────────────────────────────────────────────────────────────────
  Core     Avg Frequency(MHz)    Max Frequency(MHz)    Min Frequency(MHz)
───────────────────────────────────────────────────────────────────────────
  CPU76                 1000                  1000                  1000
───────────────────────────────────────────────────────────────────────────

─────────────────────────────────────────────────────────────────────────────────────────────────
  Function                                   cycles    Module                         cycles(%)
─────────────────────────────────────────────────────────────────────────────────────────────────
  cpu_execute_event                  87,901,471,448    sysbench                           99.82
  sb_histogram_update                   103,957,010    sysbench                            0.12
  0x800480                               25,988,818    libmysqlclient.so.21.1.23           0.03
  run_timer_softirq                      13,506,857    [kernel]                            0.02
  __clock_gettime                        12,994,230    libc-2.28.so                        0.01
─────────────────────────────────────────────────────────────────────────────────────────────────
9045 milliseconds time elapsed

If *** is displayed in Function, use --long-name to show full function name.
Callstack is saved to /home/callstack-20240606-111626.log
Flamegraph is saved to /home/Flamegraph-20240606-111626.html
The report /home/sysbench_data.tar is generated successfully.
To view summary report. you can run: devkit report -i /home/sysbench_data.tar
To view detail report. you can import the report to the WebUI or IDE to view details.
```
- 该命令将拉起并采集sysbench应用的信息，设置延迟采样时长为1秒，将会在sysbench应用启动1秒后再开始采集，--package将保留采集到的数据并生成一个tar包，-o参数指定生成文件为/home/sysbench_data。tar，后续可使用devkit report命令再次对该份报告进行查看。同时在执行应用所运行的CPU核上筛选出波动超过当前支持最大频率1%的CPU频率数据进行展示，用户可针对降频较多的CPU核进行进一步定位优化。

<br>

查看历史报告
``` shell
devkit report -i /home/DevKit-CLI-CI_VERSION_NUMBER-Linux-Kunpeng/hotspot-20240606-101635.tar
```
返回信息如下
``` shell

Hotspot Summary Report-ALL                              Time:2025/05/21 10:16:36
================================================================================

1.The current server supports a maximum of 2600 MHz CPU frequency and a minimum of 200 MHz.
2.Only the collected CPU frequency information about the running process is displayed. Considering the large number of cores, only the CPU frequency with a difference of more than 1% from the maximum CPU frequency is displayed.
For example, the collected process runs on CPUs 0-10, and only the difference between the CPU frequency of CPUs 3-6 and the maximum frequency supported by the current server exceeds 1%. In this case, CPU 3-6 is displayed.
───────────────────────────────────────────────────────────────────────────
  Core     Avg Frequency(MHz)    Max Frequency(MHz)    Min Frequency(MHz)
───────────────────────────────────────────────────────────────────────────
  CPU76                 1000                  1000                  1000
───────────────────────────────────────────────────────────────────────────

─────────────────────────────────────────────────────────────────────────────────────────────────
  Function                                   cycles    Module                         cycles(%)
─────────────────────────────────────────────────────────────────────────────────────────────────
  cpu_execute_event                  88,028,435,807    /usr/local/sysbench/bin/sy         99.82
                                                       sbench
  sb_histogram_update                    90,959,835    /usr/local/sysbench/bin/sy          0.10
                                                       sbench
  __log_finite                           12,994,928    /usr/lib64/libm-2.28.so             0.01
  sb_event_stop                          12,994,644    /usr/local/sysbench/bin/sy          0.01
                                                       sbench
  0x800480                               12,994,597    /home/xs/mysql-8/lib/libmy          0.01
                                                       sqlclient.so.21.1.23
  sb_more_events                         12,994,537    /usr/local/sysbench/bin/sy          0.01
                                                       sbench
  0x800310                               12,994,274    /home/xs/mysql-8/lib/libmy          0.01
                                                       sqlclient.so.21.1.23
─────────────────────────────────────────────────────────────────────────────────────────────────
9091 milliseconds time elapsed


```
## 6.7 访存统计分析
### 命令功能
基于CPU访问缓存和内存的PMU事件，分析存储的访问次数、命中率、带宽等相关情况。
### 命令格式
```
devkit tuner memory [-h] [-d <sec>] [-l {0, 1, 2, 3}] [-i <sec>] [-o] [-m {1, 2, 3}] [-p {100, 1000}] [-c {n,m | n-m}] [--package]
```
### 参数说明
**表1 参数说明参数**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-d/--duration</td>
    <td>--</td>
    <td>设置采集时长，单位为秒，可使用Ctrl+\取消任务或Ctrl+C停止采集并进入分析。</td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0/1/2/3</td>
    <td>
        配置日志等级。默认值为1(info)。<br>
        - 0（debug）<br>
        - 1（info）<br>
        - 2（warning）<br>
        - 3（error）
    </td>
  </tr>
  <tr>
    <td>-i/--interval</td>
    <td>--</td>
    <td>
        设置采集间隔（以秒为单位）。最小值为1秒，最大值不能超过采集时长。默认为持续时间。如果不指定间隔，不生成子报告。每个子报告中收集数据的时间取决于间隔参数。
    </td>
  </tr>
  <tr>
    <td>-m/--metric</td>
    <td>1/2/3</td>
    <td>        
        设置采样类型，默认为1（ALL）。<br>
        - 1（ALL）全部<br>
        - 2（Cache）缓存访问<br>
        - 3（DDR）DDR访问<br>
    </td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>--</td>
    <td>设置报告数据生成文件名，默认为当前所在目录。</td>
  </tr>
  <tr>
    <td>-c/--cpu</td>
    <td>--</td>
    <td>
        指定采集的CPU核数，如“0”、“0,1,2”、“0-2”。默认采集所有CPU核。
    </td>
  </tr>
  <tr>
    <td>-P/--period</td>
    <td>100/1000</td>
    <td>设置数据采集间隔。默认为1000毫秒，可选100毫秒和1000毫秒；若采集时长选择1秒，采集间隔的默认值将自动调整为100毫秒。
    </td>
  </tr>
  <tr>
    <td>--package</td>
    <td>--</td>
    <td>设置是否将数据导入数据库，并在指定输出路径中生成压缩包。</td>
  </tr> 
</table>

###使用示例

```
devkit tuner memory -d 2 -o /home/memory_result -m 1 --package
```
**说明：**
- 命令参数-d为采集时长2秒，参数-o /home/memory_result和--package生成以memory_result命名的报告数据压缩包至指定路径，参数-m 1为采集所有缓存和DDR访问数据。

返回信息如下

```
Memory Summary Report-ALL                               Time:2024/07/16 16:52:58
================================================================================

System Information                                
────────────────────────────────────────────────────────────────────────────────
Linux Kernel Version        4.19.90-2003.4.0.0036.oe1.aarch64
Cpu Type                    920                         
NUMA NODE                   0         1         2         3         
cpus                        0-31      32-63     64-95     96-127    


Percentage of core Cache miss                     
────────────────────────────────────────────────────────────────────────────────
L1D         1.33%
L1I         1.79%
L2D        28.63%
L2I        32.84%


DDR Bandwidth                                     
────────────────────────────────────────────────────────────────────────────────
ddrc_write        25.92MB/s
ddrc_read         53.76MB/s


Memory metrics of the Cache                       
────────────────────────────────────────────────────────────────────────────────
1. L1/L2/TLB Access Bandwidth and Hit Rate        
Value Format: X|Y = Bandwidth | Hit Rate          
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  CPU                   L1D                   L1I                  L2D                 L2I       L2D_TLB       L2I_TLB
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  all    1660.18MB/s|98.67%    2800.42MB/s|98.21%    375.66MB/s|71.37%    74.38MB/s|67.16%    N/A|99.38%    N/A|98.85% 
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

2. L3 Read Bandwidth and Hit Rate                 
─────────────────────────────────────────────────────────────────
  NODE    Read Hit Bandwidth    Read Bandwidth    Read Hit Rate
─────────────────────────────────────────────────────────────────
  0                 2.50MB/s         17.70MB/s           14.13%
  1                 5.82MB/s         36.51MB/s           15.95%
  2                 1.80MB/s         14.00MB/s           12.84%
  3                14.40MB/s         48.97MB/s           29.41%
─────────────────────────────────────────────────────────────────


Memory metrics of the DDRC                        
────────────────────────────────────────────────────────────────────────────────
1. DDRC_ACCESS_BANDWIDTH                          
Value Format: X|Y = DDR read | DDR write          
DDRC Read Bandwidth Bottleneck: 12500MB/s (for reference only)
Exceeding the bottleneck will significantly increase latency.
Please refer to README_ZH.md(Chapter 6.7) for specific bottleneck testing configurations.
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  NODE               DDRC_0               DDRC_1               DDRC_2                DDRC_3                 Total
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  0       0.00MB/s|0.00MB/s    0.00MB/s|0.00MB/s    8.58MB/s|3.34MB/s     0.00MB/s|0.00MB/s     8.58MB/s|3.34MB/s    
  1       0.00MB/s|0.00MB/s    0.00MB/s|0.00MB/s    0.00MB/s|0.00MB/s    22.12MB/s|9.56MB/s    22.12MB/s|9.56MB/s    
  2       0.00MB/s|0.00MB/s    0.00MB/s|0.00MB/s    7.15MB/s|9.26MB/s     0.00MB/s|0.00MB/s     7.15MB/s|9.26MB/s    
  3       0.00MB/s|0.00MB/s    0.00MB/s|0.00MB/s    0.00MB/s|0.00MB/s    15.96MB/s|3.80MB/s    15.96MB/s|3.80MB/s    
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────

2. DDRC_ACCESS_COUNT                              
Value Format: X|Y = read | write                  
──────────────────────────────────────────────────────────────────────────────────────────
  NODE                Local            Cross-die         Cross-chip                Total
──────────────────────────────────────────────────────────────────────────────────────────
  0       21,509/s|15,089/s     6,955/s| 5,550/s    2,528/s|1,332/s    30,993/s|21,972/s
  1       52,700/s|28,515/s    26,010/s| 5,603/s    4,558/s|1,956/s    83,268/s|36,075/s
  2       59,231/s|18,576/s       437/s| 3,101/s      780/s|  973/s    60,448/s|22,650/s
  3       29,718/s|15,074/s    59,419/s|13,871/s    3,509/s|2,172/s    92,646/s|31,118/s
──────────────────────────────────────────────────────────────────────────────────────────


The report /home/memory_result.tar is generated successfully.
To view summary report. you can run: devkit report -i /home/memory_result.tar
To view detail report. you can import the report to the WebUI or IDE to view details.

```
- 输出报告说明
  报告由七个部分组成，自上而下分别为系统信息、L1/L2缓存平均未命中率信息、总DDR带宽信息、L1/L2缓存带宽和命中率信息、L3缓存读带宽和命中率信息、DDRC带宽信息、DDRC访问次数信息。
  1. 系统信息
  逐行显示当前系统的linux内核版本、CPU类型、NUMA节点和CPU核的分布信息。
  2. L1L2缓存平均未命中率信息
  逐行显示当前系统CPU核的平均L1D、L1I、L2D、L2I缓存命中率。
  3. 总DDR带宽信息
  逐行显示当前系统的DDRC读写带宽信息。
  4. L1/L2缓存带宽和命中率信息
  如果用户通过-c指定了采集的CPU核，会显示每个CPU核的L1/L2缓存带宽和CPU命中率信息。如果用户未指定-c则默认采集所有CPU核的平均L1/L2缓存带宽和命中率信息。
  5. L3缓存读带宽和命中率信息
  逐行显示各NUMA节点L3缓存的读命中带宽、读带宽、命中率信息。
  6. DDRC带宽信息
  显示所有DDR控制器（DDRC）的读写带宽，通常每个NUMA节点会有4个DDRC。
  访存分析在鲲鹏920服务器测试得到了一组DDR读带宽瓶颈点，用于提示用户当前DDRC读带宽是否达到瓶颈，当DDRC读带宽到达瓶颈时，CPU和DDRC间的时延显著上升。各服务器的DDRC配置基于标准配置测试，其中920服务器的DDRC速率为2933 MT/s（仅供参考）。
  结果中DDRC Bandwidth Bottleneck为带宽瓶颈值（仅供参考），若DDRC_ACCESS_BANDWIDTH表格中有数据超过瓶颈值，将新增一行数据Saturated DDRC，以Node_n+DDRC_n+读写类型的方式指明数据位置。
  7. DDRC访问次数信息
  显示各节点的本地、跨die、跨chip和总DDRC访问次数。该信息受-c参数影响，如设置-c为0则只统计该CPU核的DDRC访问次数信息。

## 6.8 Miss事件分析
### 命令功能
利用SPE（Statistical Profiling Extension）能力对业务进行LLC Miss，TLB Miss，Remote Access，Long Latency Load等Miss类事件分析，可以有针对性地修改自己的程序，降低Miss事件发生的几率，提高程序处理性能。
**说明：**
- 采集Miss事件数据时需要服务器支持ARM SPE采集能力，配置SPE请参见配置SPE环境。
- Miss事件分析支持的操作系统为openEuler 20.xx和openEuler 22.xx；不支持虚拟机和容器环境。
### 命令格式
```
devkit tuner miss [-h] [-c {n | n,m | n-m}] [-d <sec>] [-P n] [-D <sec>] [-l {0, 1, 2, 3}] [-m {1, 2, 3, 4}] [-L n] [-i <sec>] [-r {user, kernel, all}] [-o] [-s] [-p {PID1 | PID1,PID2 | ALL}] [--package] [--long-name] [--dwarf] [workload workload...]
```
### 参数说明
**表1 参数说明参数**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-c/--cpu</td>
    <td>n | n,m | n-m</td>
    <td>指定采集的CPU核数，如“0”、“0,1,2”、“0-2”。如果同时存在-c和-p参数，则-p参数优先。</td>
  </tr>
  <tr>
    <td>-d/--duration</td>
    <td>Num</td>
    <td>
      设置采集时长，单位为秒，最小值为1。不设置时默认为一直采集，可使用Ctrl+\取消任务或Ctrl+C停止采集并进入分析。
    </td>
  </tr>
  <tr>
    <td>-p/--period</td>
    <td>Num</td>
    <td>
      单位为Cycle，设置指令数采样间隔，默认8092，可选择1024-2^32-1。
    </td>
  </tr>
  <tr>
    <td>-D/--delay</td>
    <td>Num</td>
    <td>设置延迟采样时长，不指定时默认为0秒。可用于应用启动后延迟采集的开始时间，最大值不能超过-d。</td>
  </tr>
  <tr>
    <td>-i/--interval</td>
    <td>Num</td>
    <td>设置采样间隔（以秒为单位）。最小值为1秒，最大值不能超过采集时长。默认为持续时间。如果不指定间隔，不生成子报告。每个子报告中收集数据的时间取决于间隔参数。</td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0/1/2/3</td>
    <td>
        配置日志等级。默认值为1(info)。<br>
        - 0（debug）<br>
        - 1（info）<br>
        - 2（warning）<br>
        - 3（error）
    </td>
  </tr>
  <tr>
    <td>-m/--metric</td>
    <td>1/2/3/4</td>
    <td>选择采集数据的等级。默认为1（LLC Miss）。<br>
    1（LLC Miss）：内存请求在最后一级Cache中未命中的次数。<br>
    2（TLB Miss）：CPU在内存访问或取址过程中，在TLB中没有找到虚拟地址到物理地址映射次数。<br>
    3（Remote Access）：跨CPU访问远程DRAM的次数。<br>
    4（Long Latency Load）：跨CPU访问远程DRAM，并且访问时延超过设定的最小时延的次数。
</td>
  </tr>
  <tr>
    <td>-t/--top</td>
    <td>Num</td>
    <td>选择要展示的TopN数据，最小值为1，默认为10。</td>
  </tr> 
  <tr>
    <td>-L/--latency</td>
    <td>Num</td>
    <td>设置最小延迟（时钟周期），在采集Long Latency Load数据时可以设置，默认为64。可选范围为1-4095。</td>
  </tr> 
  <tr>
    <td>-o/--output</td>
    <td>file</td>
    <td>设置报告数据生成文件名，不指定时默认为当前所在目录。</td>
  </tr>
  <tr>
    <td>-r/--clloection-range</td>
    <td>user/kernel/all</td>
    <td>
        设置采集模式，不指定时默认为all。
        all：采集用户态和内核态的性能数据。
        user：采集用户态的性能数据。kernel：采集内核态的性能数据。
    </td>
  </tr>
  <tr>
    <td>-s/--src-dir</td>
    <td>dir</td>
    <td>
        指定源码工程目录，用于查找并关联源码，需要将任务导入web端进行查看。
    </td>
  </tr>  
  <tr>
    <td>-p/--pid</td>
    <td>PID1 | PID1,PID2 | ALL</td>
    <td>
      指定采集的进程PID，多个进程PID可用“,”分隔。若同时使用-p和-c参数则优先采集指定PID的进程，若不指定默认采集全部进程。
    </td>
  </tr>
  <tr>
    <td>--long-name</td>
    <td>--</td>
    <td>
      设置是否显示详细函数和模块信息。不使用此参数默认简洁显示模块或功能信息。
    </td>
  </tr>
  <tr>
    <td>--dwarf</td>
    <td>--</td>
    <td>
      设置是否关联 C/C++ 的源代码文件。
    </td>
  </tr>
  <tr>
    <td>--package</td>
    <td>--</td>
    <td>
      设置是否将数据导入数据库，并在指定输出路径中生成压缩包。
    </td>
  </tr>
</table>

### 使用示例
- 对系统采集：

```
devkit tuner miss -c 0-127 -d 5 -o /home/miss_report -m 1 --package
```
**说明：**
- 该命令参数-c 0-127采集0到127的CPU核，采集时长为5秒，参数-o /home/miss_report和--package生成以miss_report命名的报告数据压缩包至指定路径，参数-m 1表示采集LLC Miss事件信息。

返回信息如下

```
Miss Summary Report-all                                 Time:2024/06/11 16:04:38
================================================================================

──────────────────────────────────────────────────────────────────────────────────────────
  Function                       Module                                        LLC Miss
──────────────────────────────────────────────────────────────────────────────────────────
  UNKNOWN                        /usr/lib64/l***read-2.28.so         35,643,392 (89.55%)
  find_busiest_group             [kernel]                               270,336 (0.68%)
  UNKNOWN                        /home/devkit***on3.9.so.1.0            253,952 (0.64%)
  UNKNOWN                        /usr/lib64/libc-2.28.so                253,952 (0.64%)
  pthread_mutex_lock             /usr/lib64/l***read-2.28.so            188,416 (0.47%)
  _PyEval_EvalFrameDefault       /home/devkit***on3.9.so.1.0            180,224 (0.45%)
  copy_page                      [kernel]                               172,032 (0.43%)
  futex_wait                     [kernel]                               172,032 (0.43%)
  UNKNOWN                        /usr/bin/dev***ib/libsym.so            155,648 (0.39%)
  std::_Sp_cou***_M_release()    /usr/bin/dev***/libtuner.so            147,456 (0.37%)
──────────────────────────────────────────────────────────────────────────────────────────
6192 milliseconds time elapsed

```

- 对应用采集：

```
devkit tuner miss -d 5 --package /opt/testdemo/cache_miss
```
返回信息如下：

```
Miss Summary Report-all                                 Time:2024/06/11 16:03:15
================================================================================

──────────────────────────────────────────────────────────────────────────────────────────
  Function                       Module                                        LLC Miss
──────────────────────────────────────────────────────────────────────────────────────────
  main                           /opt/testdemo/cache_miss            41,361,408 (99.29%)
  change_protection_range        [kernel]                               106,496 (0.26%)
  armpmu_dispatch_irq            [kernel]                                81,920 (0.20%)
  run_posix_cpu_timers           [kernel]                                57,344 (0.14%)
  queued_spin_lock_slowpath      [kernel]                                32,768 (0.08%)
  perf_event_task_tick           [kernel]                                 8,192 (0.02%)
  trigger_load_balance           [kernel]                                 8,192 (0.02%)
──────────────────────────────────────────────────────────────────────────────────────────
6039 milliseconds time elapsed

```

- 对PID采集：

```
devkit tuner miss -d 5 --package -p 414192
```
返回信息如下：

```
Miss Summary Report-all                                 Time:2024/06/11 16:05:53
================================================================================

──────────────────────────────────────────────────────────────────────────────────────────
  Function                       Module                                        LLC Miss
──────────────────────────────────────────────────────────────────────────────────────────
  UNKNOWN                        /usr/lib64/l***read-2.28.so         36,765,696 (82.32%)
  pthread_mutex_lock             /usr/lib64/l***read-2.28.so          3,137,536 (7.02%)
  futex_wait                     [kernel]                             3,096,576 (6.93%)
  __arm64_sys_futex              [kernel]                             1,064,960 (2.38%)
  get_futex_value_locked         [kernel]                               139,264 (0.31%)
  fun2                           /opt/testdem***d_mutex_long            106,496 (0.24%)
  UNKNOWN                        /opt/testdem***d_mutex_long             90,112 (0.20%)
  __list_del_entry_valid         [kernel]                                81,920 (0.18%)
  queued_spin_lock_slowpath      [kernel]                                40,960 (0.09%)
  perf_event_task_tick           [kernel]                                24,576 (0.06%)
──────────────────────────────────────────────────────────────────────────────────────────
6060 milliseconds time elapsed

If *** is displayed in Function or Module, use --long-name to show full name.
The report /usr/bin/devkit/miss-20240611-160547.tar is generated successfully.
To view summary report. you can run: devkit report -i /usr/bin/devkit/miss-20240611-160547.tar
To view detail report. you can import the report to the WebUI or IDE to view details.

```
- 查看已生成报告：

```
devkit report -i /usr/bin/devkit/miss-20240611-160547.tar
```
返回信息如下：

```
./devkit report -i /usr/bin/devkit/miss-20240611-160547.tar
───────────────────────────────────────────────────────────────────────────────────────────────
  Function                          Module                                           LLC Miss
───────────────────────────────────────────────────────────────────────────────────────────────
  UNKNOWN                         /usr/lib64/libpthread-2.28.so          36,765,696 (82.32%) 
  pthread_mutex_lock              /usr/lib64/libpthread-2.28.so           3,137,536 (7.02%)
  futex_wait                      [kernel]                                3,096,576 (6.93%)
  __arm64_sys_futex               [kernel]                                1,064,960 (2.38%)
  get_futex_value_locked          [kernel]                                  139,264 (0.31%)
  fun2                            /opt/testdemo/pthread_mutex_long          106,496 (0.24%)
  UNKNOWN                         /opt/testdemo/pthread_mutex_long           90,112 (0.20%)
  __list_del_entry_valid          [kernel]                                   81,920 (0.18%)
  queued_spin_lock_slowpath       [kernel]                                   40,960 (0.09%)
  perf_event_task_tick            [kernel]                                   24,576 (0.06%)
───────────────────────────────────────────────────────────────────────────────────────────────
6060 milliseconds time elapsed


```

# 7 Python性能分析

## 7.1 介绍

### 命令功能
Python性能分析使用ptrace对Python程序和Python&C/C++混合程序进行采集，分析调用栈，获取top 20热点函数，并且绘制火焰图。
```text
[说明]
- 仅支持Python 3.7.X - 3.11.X版本。
- 仅支持openEuler操作系统。
- 仅支持PID模式的采集和分析。
```

### 命令格式
```shell
devkit py-perf hotspot [-h] [-l {0,1,2,3}] [-d <sec>] [-i <msec>] [-p {PID}] [-o <file>] [-t] [--native] [--nolineno]
```

### 参数说明
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0/1/2/3</td>
    <td>
        配置日志等级。默认值为1(info)。<br>
        - 0（debug）<br>
        - 1（info）<br>
        - 2（warning）<br>
        - 3（error）
    </td>
  </tr>
  <tr>
    <td>-d/--duration</td>
    <td>Num</td>
    <td>设置采集时长（以秒为单位）。最小值为1秒，不设置时默认为一直采集，可使用Ctrl+\取消任务或Ctrl+C停止采集并进入分析。</td>
  </tr>
  <tr>
    <td>-i/--interval</td>
    <td>Num</td>
    <td>设置采集间隔（以毫秒为单位）。取值范围1~1000毫秒，默认为10毫秒。</td>
  </tr>
  <tr>
    <td>-p/--pid</td>
    <td>PID</td>
    <td>
      指定采集的进程PID。仅对目标进程进行采样，不会采集目标进程的子进程。
    </td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>file</td>
    <td>设置报告数据文件名，不设置时默认在当前所在路径生成FlameGraph-YMD-HMS.html。</td>
  </tr>
  <tr>
    <td>-t/--thread</td>
    <td>--</td>
    <td>表示火焰图是否基于线程展示栈信息。如果使用此参数，则基于线程展示栈信息，否则，基于进程合并，不显示线程。</td>
  </tr>
  <tr>
    <td>--native</td>
    <td>--</td>
    <td>表示是否采集Python和C调用栈。如果使用此参数，则采集Python和C调用栈，否则，仅采集Python调用栈。</td>
  </tr>
  <tr>
    <td>--nolineno</td>
    <td>--</td>
    <td>表示是否显示行号。如果使用此参数，则热点函数和火焰图不显示行号，否则，显示行号。</td>
  </tr>
</table>

### 使用示例
采集指定PID的进程:
```shell
devkit py-perf hotspot -p 2082596 -d 5 -i 100 -o /home/demo/flamegraph -t --native
```
```text
[说明]
- -p 2082596参数表示采集进程ID为2082596的信息。
  -d 5参数表示采集时长为5秒。
  -i 100参数表示采集间隔为100毫秒。
  -o /home/demo/flaregraph参数表示在/home/demo/目录下生成.html文件。
- 命令输出包含太多的堆栈信息，其中大部分已被省略，以便于阅读。具体信息请以实际回显为准。
```
返回信息如下：
```shell
Press Ctrl+ \ to cancel the task or Ctrl+ C to stop the task collection and enter the analysis.

Python Hotspot Top20 Summary Report                     Time:2024/08/13 15:07:16
================================================================================ 

────────────────────────────────────────────────────────────────────────────────────────────────
  Function                                                           Runtime(ms)    Runtime(%)
────────────────────────────────────────────────────────────────────────────────────────────────
  pthread_condattr_setpshared                                               4722         82.04
      pthread_condattr_setpshared
      clone
	  
  blas_thread_server                                                         447          7.77
      blas_thread_server
      pthread_condattr_setpshared
      clone

  ...
  ...
  ...  

  scipy_dgebal_64_                                                             9          0.16
      scipy_dgebal_64_
      scipy_dgeev_64_
      void eig_wrapper<f2c_doublecomplex, double>(char, char, char**, long const*, long const*) [clone .constprop.0]
      generic_wrapped_legacy_loop
      ufunc_generic_fastcall 
      _PyEval_EvalFrameDefault 
      _PyEval_EvalFrameDefault 
      dispatcher_vectorcall 
      _PyEval_EvalFrameDefault 
      _PyEval_EvalFrameDefault 
      _PyEval_EvalFrameDefault 
      _PyEval_EvalFrameDefault 
      _PyEval_EvalFrameDefault 
      eig (/usr/local/lib64/python3.9/site-packages/numpy/linalg/_linalg.py:1702) 
      compute_eigenvalues (/home/jjl/workspace/pyhotstpot_demo/ai-demo/numpy_test_1.py:10) 
      run (/usr/lib64/python3.9/concurrent/futures/thread.py:58) 
      _worker (/usr/lib64/python3.9/concurrent/futures/thread.py:83) 
      run (/usr/lib64/python3.9/threading.py:910) 
      _bootstrap_inner (/usr/lib64/python3.9/threading.py:973) 
      _bootstrap (/usr/lib64/python3.9/threading.py:930) 
      PyCodec_StreamReader 
      _PyGC_CollectNoFail 
      _Py_hashtable_destroy 
      pthread_condattr_setpshared 
      clone

  dgemm_nn                                                                     9          0.16
      dgemm_nn

────────────────────────────────────────────────────────────────────────────────────────────────
The flamegraph html report: /home/demo/flamegraph.html
```


# 8 系统诊断分析

## 8.1 介绍

### 命令功能
查看系统诊断分析支持任务的帮助信息。

### 命令格式
查看所有命令参数说明。
```shell
devkit doctor -h
```

### 使用实例
运行以下命令，查看所有命令参数说明。
```shell
devkit doctor -h
```
返回信息如下：
```shell
Usage: devkit doctor [-h | --help] TASK [ARGS]

 The most commonly used devkit doctor sub tasks are:
   help       Get help information
   memalloc   Run the memory allocate collection and analysis task

 See 'devkit doctor TASK --help' for more information on a specific task.
```



## 8.2 内存使用分析

### 命令功能
基于bcc进行内存分配、释放性能数据采集。检查应用中的内存分配未释放的情况。

### 命令格式
```shell
devkit doctor memalloc [-h] [-l {0,1,2,3}] [--package] [-o <file>] [-d <sec>] [-i <sec>] [-t n] [-z <byte>] [-Z <byte>] [-p PID] [workload workload...]
```

### 参数说明
**表1 参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-d/--duration</td>
    <td>Num</td>
    <td>
      设置采集时长，单位为秒，不设置时默认为一直采集。<br>
      可使用Ctrl+C组合键停止采集并进入分析。
    </td>
  </tr>
  <tr>
    <td>-i/--interval</td>
    <td>Num</td>
    <td>
      设置采样间隔，不设置时默认为1秒。
    </td>
  </tr>
    <tr>
    <td>-t/--top</td>
    <td>Num</td>
    <td>
      按照堆栈从大到小顺序展示Top n的数据，范围为5-15，默认值为5。
    </td>
  </tr>
   </tr>
    <tr>
    <td>-z/--min-size</td>
    <td>Byte</td>
    <td>
      内存大小过滤最小值。
    </td>
  </tr>
   </tr>
    <tr>
    <td>-Z/--max-size</td>
    <td>Byte</td>
    <td>
      内存大小过滤最大值。
    </td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      配置日志等级。默认值2(warning)。<br>
      - 0（debug）<br>
      - 1（info）<br>
      - 2（warning）<br>
      - 3（error）
    </td>
  <tr>
    <td>-o/--output</td>
    <td>file</td>
    <td>
      设置报告数据文件名，不设置时默认在当前所在路径生成memalloc-xxxx-xxxx.tar。<br>
      指定名称时，例如/opt/report1, 则在/opt下生成report1.tar，若存在同名文件，则报错不生成。
    </td>
  </tr>
  <tr>
    <td>-p/--pid</td>
    <td>PID</td>
    <td>
      指定采集的进程PID，仅支持关联一个pid。<br>
      默认-1监控内核态内存使用。<br>
      若同时使用-p和workload参数则优先采集指定workload的进程。
    </td>
  </tr>
  <tr>
    <td>--package</td>
    <td>--</td>
    <td>
      该参数指定情况下才会落盘生成tar包报告。
    </td>
  </tr>
</table>

### 使用示例
- 针对PID采集
  命令：

```shell
devkit doctor memalloc -d 1
```

```text
[说明]
该命令参数-d，表示采集时长为1秒。
没有输入-p参数默认为-1，表示采集内核内存分配。
```

结果回显

```shell
  
Attaching to kernel allocators, Ctrl+C to quit.


Memory Allocate Summary Report-1                        Time:2024/07/23 15:48:22
================================================================================

Top 5 stacks with outstanding allocations:

Top 1 stack
────────────────────────────────────────────────────────────────────────────────
stack_name                __traceiter_mm_page_alloc+0x60 [kernel]
stack_id                  12987
alloc_size                1204224B
alloc_count               294
alloc_distribution        4KB-8KB 294

stack_info:
0xffffaadd83dcc1e0        __traceiter_mm_page_alloc+0x60 [kernel]
0xffffaadd83dcc1e0        __traceiter_mm_page_alloc+0x60 [kernel]
0xffffaadd83e13d64        __alloc_pages+0xf90 [kernel]
0xffffaadd83e3ef88        alloc_pages_vma+0xa8 [kernel]
0xffffaadd83de3cb4        do_anonymous_page+0x1d4 [kernel]
0xffffaadd83de9b5c        handle_pte_fault+0x19c [kernel]
0xffffaadd83debad0        __handle_mm_fault+0x1b0 [kernel]
0xffffaadd83debda4        handle_mm_fault+0xf4 [kernel]
0xffffaadd847c0f68        do_page_fault+0x188 [kernel]
0xffffaadd847c12ec        do_translation_fault+0xb8 [kernel]
0xffffaadd83aff5b8        do_mem_abort+0x48 [kernel]
0xffffaadd847b2444        el0_da+0x44 [kernel]
0xffffaadd847b2cc8        el0_sync_handler+0x88 [kernel]
0xffffaadd83ac2560        el0_sync+0x160 [kernel]

Top 2 stack
────────────────────────────────────────────────────────────────────────────────
stack_name                __traceiter_mm_page_alloc+0x60 [kernel]
stack_id                  2088
alloc_size                933888B
alloc_count               228
alloc_distribution        4KB-8KB 228

stack_info:
0xffffaadd83dcc1e0        __traceiter_mm_page_alloc+0x60 [kernel]
0xffffaadd83dcc1e0        __traceiter_mm_page_alloc+0x60 [kernel]
0xffffaadd83e13d64        __alloc_pages+0xf90 [kernel]
0xffffaadd83e5c59c        alloc_misplaced_dst_page+0x2c [kernel]
0xffffaadd83e5f3cc        unmap_and_move+0x68 [kernel]
0xffffaadd83e5fbdc        migrate_pages+0x16c [kernel]
0xffffaadd83e608d8        migrate_misplaced_page+0x128 [kernel]
0xffffaadd83de616c        do_numa_page+0x2bc [kernel]
0xffffaadd83de9b78        handle_pte_fault+0x1b8 [kernel]
0xffffaadd83debad0        __handle_mm_fault+0x1b0 [kernel]
0xffffaadd83debda4        handle_mm_fault+0xf4 [kernel]
0xffffaadd847c0f68        do_page_fault+0x188 [kernel]
0xffffaadd847c12ec        do_translation_fault+0xb8 [kernel]
0xffffaadd83aff5b8        do_mem_abort+0x48 [kernel]
0xffffaadd847b2444        el0_da+0x44 [kernel]
0xffffaadd847b2cc8        el0_sync_handler+0x88 [kernel]
0xffffaadd83ac2560        el0_sync+0x160 [kernel]

Top 3 stack
────────────────────────────────────────────────────────────────────────────────
stack_name                __traceiter_mm_page_alloc+0x60 [kernel]
stack_id                  10563
alloc_size                32768B
alloc_count               1
alloc_distribution        32KB-64KB 1

stack_info:
0xffffaadd83dcc1e0        __traceiter_mm_page_alloc+0x60 [kernel]
0xffffaadd83dcc1e0        __traceiter_mm_page_alloc+0x60 [kernel]
0xffffaadd83e13d64        __alloc_pages+0xf90 [kernel]
0xffffaadd83e3f484        alloc_pages+0x90 [kernel]
0xffffaadd83dcf188        kmalloc_order+0x38 [kernel]
0xffffaadd83dcf338        kmalloc_order_trace+0x38 [kernel]
0xffffaadd83e5446c        __kmalloc+0x51c [kernel]
0xffffaadd83d1ddd4        map_lookup_elem+0x154 [kernel]
0xffffaadd83d20d5c        __se_sys_bpf+0x658 [kernel]
0xffffaadd83d20de4        __arm64_sys_bpf+0x24 [kernel]
0xffffaadd83adb9a4        invoke_syscall+0x50 [kernel]
0xffffaadd83adbbc8        el0_svc_common.constprop.0+0x158 [kernel]
0xffffaadd83adbc00        do_el0_svc+0x2c [kernel]
0xffffaadd847b23f0        el0_svc+0x20 [kernel]
0xffffaadd847b2cf0        el0_sync_handler+0xb0 [kernel]
0xffffaadd83ac2560        el0_sync+0x160 [kernel]

Top 4 stack
────────────────────────────────────────────────────────────────────────────────
stack_name                __traceiter_mm_page_alloc+0x60 [kernel]
stack_id                  1491
alloc_size                32768B
alloc_count               1
alloc_distribution        32KB-64KB 1

stack_info:
0xffffaadd83dcc1e0        __traceiter_mm_page_alloc+0x60 [kernel]
0xffffaadd83dcc1e0        __traceiter_mm_page_alloc+0x60 [kernel]
0xffffaadd83e13d64        __alloc_pages+0xf90 [kernel]
0xffffaadd83e3f484        alloc_pages+0x90 [kernel]
0xffffaadd83e4dc7c        allocate_slab+0x3ac [kernel]
0xffffaadd83e52150        ___slab_alloc+0x2d0 [kernel]
0xffffaadd83e52364        __slab_alloc+0x34 [kernel]
0xffffaadd83e52864        kmem_cache_alloc+0x4c4 [kernel]
0xffffaadd83d8f6f8        mempool_alloc_slab+0x24 [kernel]
0xffffaadd83d8fc90        mempool_alloc+0x70 [kernel]
0xffffaadd84066aa8        bvec_alloc+0xd8 [kernel]
0xffffaadd84066cfc        bio_alloc_bioset+0x1e8 [kernel]
0xffffaadd0b558688        io_submit_init_bio+0x38 [ext4]
0xffffaadd0b558a00        ext4_bio_write_page+0x240 [ext4]
0xffffaadd0b52d8b4        mpage_submit_page+0x64 [ext4]
0xffffaadd0b52e268        mpage_map_and_submit_buffers+0xc8 [ext4]
0xffffaadd0b534d08        mpage_map_and_submit_extent+0x68 [ext4]
0xffffaadd0b535490        ext4_writepages+0x580 [ext4]
0xffffaadd83d999c0        do_writepages+0x60 [kernel]
0xffffaadd83ef668c        __writeback_single_inode+0x4c [kernel]
0xffffaadd83ef6f94        writeback_sb_inodes+0x234 [kernel]
0xffffaadd83ef73e4        __writeback_inodes_wb+0x54 [kernel]
0xffffaadd83ef7954        wb_writeback+0x364 [kernel]
0xffffaadd83ef7e64        wb_do_writeback+0x1d4 [kernel]
0xffffaadd83ef8f40        wb_workfn+0x80 [kernel]
0xffffaadd83b82f48        process_one_work+0x1d4 [kernel]
0xffffaadd83b83388        worker_thread+0x158 [kernel]
0xffffaadd83b8b8cc        kthread+0x108 [kernel]
0xffffaadd83ac7068        ret_from_fork+0x10 [kernel]

Top 5 stack
────────────────────────────────────────────────────────────────────────────────
stack_name                kmalloc_order_trace+0xec [kernel]
stack_id                  13367
alloc_size                32768B
alloc_count               1
alloc_distribution        32KB-64KB 1

stack_info:
0xffffaadd83dcf3ec        kmalloc_order_trace+0xec [kernel]
0xffffaadd83dcf3ec        kmalloc_order_trace+0xec [kernel]
0xffffaadd83e5446c        __kmalloc+0x51c [kernel]
0xffffaadd83d1ddd4        map_lookup_elem+0x154 [kernel]
0xffffaadd83d20d5c        __se_sys_bpf+0x658 [kernel]
0xffffaadd83d20de4        __arm64_sys_bpf+0x24 [kernel]
0xffffaadd83adb9a4        invoke_syscall+0x50 [kernel]
0xffffaadd83adbbc8        el0_svc_common.constprop.0+0x158 [kernel]
0xffffaadd83adbc00        do_el0_svc+0x2c [kernel]
0xffffaadd847b23f0        el0_svc+0x20 [kernel]
0xffffaadd847b2cf0        el0_sync_handler+0xb0 [kernel]
0xffffaadd83ac2560        el0_sync+0x160 [kernel]

```

- 针对APP采集
  命令：

```shell
devkit doctor memalloc -d 10 /opt/testdemo/accurate_data_memory_leak
```

```text
[说明]
该命令对程序/opt/testdemo/accurate_data_memory_leak进行采集，采集时长为10秒（若应用本身运行时长短于10， 任务会提前结束)
```

结果回显

```shell

Executing "/opt/testdemo/accurate_data_memory_leak" and tracing the resulting process.
Attaching to pid 2620561, Ctrl+C to quit.

Memory Allocate Summary Report-1                        Time:2024/07/23 15:53:15
================================================================================

Top 5 stacks with outstanding allocations:

Top 1 stack
────────────────────────────────────────────────────────────────────────────────
stack_name                [unknown] [ld-linux-aarch64.so.1]
stack_id                  8959
alloc_size                288B
alloc_count               1
alloc_distribution        256B-512B 1

stack_info:
0x0000ffffa5cfe9f4        [unknown] [ld-linux-aarch64.so.1]
0x0000ffffa5cff210        _dl_allocate_tls+0x10 [ld-linux-aarch64.so.1]
0x0000ffffa594dd2c        pthread_create+0x92c [libc.so.6]
0x0000ffffa5c06c64        std::thread::_M_start_thread   (std::unique_ptr<std::thread::_State, std::default_delete<std::thread::_State> >, void (*)())+0x24 [l
                          ibstdc++.so.6]
0x0000000000401020        std::thread::thread<void (&)(), , void>(void (&)())+0x58 [accurate_data_memory_leak]
0x0000000000400e20        func_thread()+0x20 [accurate_data_memory_leak]
0x0000000000400e94        main+0x14 [accurate_data_memory_leak]
0x0000ffffa58f5fc0        [unknown] [libc.so.6]
0x0000ffffa58f6098        __libc_start_main+0x94 [libc.so.6]
0x0000000000400cb0        _start+0x30 [accurate_data_memory_leak]

Memory Allocate Summary Report-2                        Time:2024/07/23 15:53:16
================================================================================

Top 5 stacks with outstanding allocations:

Top 1 stack
────────────────────────────────────────────────────────────────────────────────
stack_name                [unknown] [ld-linux-aarch64.so.1]
stack_id                  8959
alloc_size                288B
alloc_count               1
alloc_distribution        256B-512B 1

stack_info:
0x0000ffffa5cfe9f4        [unknown] [ld-linux-aarch64.so.1]
0x0000ffffa5cff210        _dl_allocate_tls+0x10 [ld-linux-aarch64.so.1]
0x0000ffffa594dd2c        pthread_create+0x92c [libc.so.6]
0x0000ffffa5c06c64        std::thread::_M_start_thread(std::unique_ptr<std::thread::_State, std::default_delete<std::thread::_State> >, void (*)())+0x24 [l
                          ibstdc++.so.6]
0x0000000000401020        std::thread::thread<void (&)(), , void>(void (&)())+0x58 [accurate_data_memory_leak]
0x0000000000400e20        func_thread()+0x20 [accurate_data_memory_leak]
0x0000000000400e94        main+0x14 [accurate_data_memory_leak]
0x0000ffffa58f5fc0        [unknown] [libc.so.6]
0x0000ffffa58f6098        __libc_start_main+0x94 [libc.so.6]
0x0000000000400cb0        _start+0x30 [accurate_data_memory_leak]

Memory Allocate Summary Report-3                        Time:2024/07/23 15:53:17
================================================================================

Top 5 stacks with outstanding allocations:

Top 1 stack
────────────────────────────────────────────────────────────────────────────────
stack_name                [unknown] [ld-linux-aarch64.so.1]
stack_id                  8959
alloc_size                288B
alloc_count               1
alloc_distribution        256B-512B 1

stack_info:
0x0000ffffa5cfe9f4        [unknown] [ld-linux-aarch64.so.1]
0x0000ffffa5cff210        _dl_allocate_tls+0x10 [ld-linux-aarch64.so.1]
0x0000ffffa594dd2c        pthread_create+0x92c [libc.so.6]
0x0000ffffa5c06c64        std::thread::_M_start_thread(std::unique_ptr<std::thread::_State, std::default_delete<std::thread::_State> >, void (*)())+0x24 [l
                          ibstdc++.so.6]
0x0000000000401020        std::thread::thread<void (&)(), , void>(void (&)())+0x58 [accurate_data_memory_leak]
0x0000000000400e20        func_thread()+0x20 [accurate_data_memory_leak]
0x0000000000400e94        main+0x14 [accurate_data_memory_leak]
0x0000ffffa58f5fc0        [unknown] [libc.so.6]
0x0000ffffa58f6098        __libc_start_main+0x94 [libc.so.6]
0x0000000000400cb0        _start+0x30 [accurate_data_memory_leak]

```
```
- 输出报告说明
  报告由每个子报告组成，当前子报告展示了-t参数输入的top n的栈的信息（从大到小），若不存在n个那就只展示存在的个数。
  具体下发依次展示了栈名，栈id，当前内存已分配但未释放的大小（byte）,分配次数，分配块大小及个数，最后是栈信息。
```
内存使用详细信息可通过--package参数打包生成TAR包，导入Web界面查看图形化信息。


# 9 HPC调试器

## 9.1 HPC调试器功能说明

### 命令功能
支持对MPI及MPI+OpenMP程序进行Launch调试，仅支持mpirun命令运行方式。
支持对MPI及MPI+OpenMPI程序进行Attach调试，仅支持Slurm调度器运行方式。

### 命令格式
- launch 
```shell
debugger launch [-h | --help] {-w APP_WORKLOAD | --workload APP_WORKLOAD} {-s SOURCE_PATH | --source SOURCE_PATH} {-m MPIRUN_CMD | --mpicmd MPIRUN_CMD} {-p RPC_SERVER_PORT | --port RPC_SERVER_PORT} [-l {0,1,2,3} | --log-level {0,1,2,3}] [-e ENVIRONMENT_VARIABLES | --env ENVIRONMENT_VARIABLES] [-a APP_ARGS | --args APP_ARGS] [-n THREAD_NUM | --threads THREAD_NUM]
```

- attach
```shell
debugger attach [-h | --help] {-w APP_WORKLOAD | --workload APP_WORKLOAD} {-s SOURCE_PATH | --source SOURCE_PATH}{-r RUN_MODE | --run-mode RUN_MODE}{-j JOB_ID | --job JOB_ID} {-p RPC_SERVER_PORT | --port RPC_SERVER_PORT} [-l {0,1,2,3} | --log-level {0,1,2,3}] [-e ENVIRONMENT_VARIABLES | --env ENVIRONMENT_VARIABLES]
```

### 参数说明
**表1 launch命令参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-w/--workload</td>
    <td>APP_WORKLOAD</td>
    <td>
      必选参数，待调试程序可执行文件路径。<br>
      例如：/home/test/mpi_demo
    </td>
  </tr>
  <tr>
    <td>-s/--source</td>
    <td>SOURCE_PATH</td>
    <td>
      必选参数，待调试程序源码文件目录。<br>
      例如：/home/test
    </td>
  </tr>
  <tr>
    <td>-m/--mpicmd</td>
    <td>MPIRUN_CMD</td>
    <td>
      必选参数，需执行的mpirun命令，需使用英文双引号引起来。<br>
      例如：“mpirun --allow-run-as-root -np 4”
    </td>
  </tr>
  <tr>
    <td>-e/--env</td>
    <td>ENVIRONMENT_VARIABLES</td>
    <td>
     设置环境变量，设置时需使用英文双引号引起来。有以下3种方式可选，可根据实际情况进行修改。<br>
      - export PATH=$PATH:/path/to/mpi <br>
      - source /configure/mpi/path/file <br>
      - module load /mpi/modulefiles <br>
      例如：“export PATH=$PATH:/path/to/mpi”
    </td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      配置日志等级。默认值为1(info)。<br>
      - 0（debug）<br>
      - 1（info）<br>
      - 2（warning）<br>
      - 3（error）
    <td>
  </tr>
  <tr>
    <td>-a/--args</td>
    <td>APP_ARGS</td>
    <td>
      设置待调试程序运行参数，若存在多个参数需使用空格隔开。
    </td>
  </tr>
  <tr>
    <td>-p/--port</td>
    <td>RPC_SERVER_PORT</td>
    <td>
      必选参数，Agent Server运行端口号，设置后用于上报启动信息。
    </td>
  </tr>
  <tr>
    <td>-n/--thread</td>
    <td>THREAD_NUMS</td>
    <td>
      输入的OpenMP应用thread数量。
    </td>
  <tr>
</table>

**表2 attach命令参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-w/--workload</td>
    <td>APP_WORKLOAD</td>
    <td>
      必选参数，待调试程序可执行文件路径。<br>
      例如：/home/test/mpi_demo
    </td>
  </tr>
  <tr>
    <td>-s/--source</td>
    <td>SOURCE_PATH</td>
    <td>
      必选参数，待调试程序源码文件目录。<br>
      例如：/home/test
    </td>
  </tr>
  <tr>
    <td>-r/--run-mode</td>
    <td>RUN_MODE</td>
    <td>
      必选参数，指定程序的运行方式，仅支持Slurm调度器运行方式。
    </td>
  </tr>
  <tr>
    <td>-j/--job</td>
    <td>JOB_ID</td>
    <td>
      必选参数，指定job ID。
    </td>
  </tr>
  <tr>
    <td>-e/--env</td>
    <td>ENVIRONMENT_VARIABLES</td>
    <td>
     设置环境变量，设置时需使用英文双引号引起来。有以下3种方式可选，可根据实际情况进行修改。<br>
      - export PATH=$PATH:/path/to/mpi <br>
      - source /configure/mpi/path/file <br>
      - module load /mpi/modulefiles <br>
      例如：“export PATH=$PATH:/path/to/mpi”
    </td>
  </tr>
  <tr>
    <td>-l/--log-level</td>
    <td>0,1,2,3</td>
    <td>
      配置日志等级。默认值为1(info)。<br>
      - 0（debug）<br>
      - 1（info）<br>
      - 2（warning）<br>
      - 3（error）
    <td>
  </tr>
  <tr>
    <td>-p/--port</td>
    <td>RPC_SERVER_PORT</td>
    <td>
      必选参数，Agent Server运行端口号，设置后用于上报启动信息。
    </td>
  </tr>
</table>


### 使用示例
- 执行以下命令，查看HPC调试器支持的功能信息：
命令：
```shell
devkit debugger -h
```
结果回显
```shell
 The most commonly used debugger sub commands are:
   launch              Starts and debugs a program directly from the development environment.
   attach              Connects the debugger to an already running process for real-time debugging.
 See 'COMMAND -h/--help' for more information on a specific command.

```

## 9.2 help帮助命令

### 命令功能

- 启动程序后，查看HPC调试器调试命令的帮助信息。

### 命令格式
```shell
help
```

### 使用示例
执行以下命令，查看帮助信息：
```shell
(kpdb) help
```
结果回显
```shell
The most commonly used debugger sub commands are:
   help                Get help information.
   breakpoint          Adds, views, and deletes breakpoints.
   rank                Displays the rank information and sets the current rank.
   group               Displays the communication subgroup information and sets the current communication subgroup. (Not supported in 'attach' mode)
   thread              Displays the thread information and sets the current thread.
   variable            Displays and modifies variables.
   register            Displays and modifies registers.
   stack               Displays the stack information and switches between stack frames.
   list                Displays the code context of the current pause location of the application.
   continue            Executes the application to the next breakpoint or until the application ends.
   next                Executes the current line and jumps to the next line of code (without entering the function).
   step-in             Executes the current line. If a function is called, enter this function.
   step-out            Finishes the execution in the function and returns to the calling location.
   pause               Manually suspends the running application.
   quit                Terminates the debugging session and exits the application immediately.
 See 'COMMAND -h/--help' for more information on a specific command.

```

## 9.3 调试状态命令

### 9.3.1 breakpoint断点命令

#### 命令功能

- 设置、删除、查看断点。

#### 命令格式
- 设置断点：
```shell
breakpoint set [-h | --help] {-f FILE_NAME | --file FILE_NAME} {-l LINE_NUMBER | --line LINE_NUMBER} [-r RANK_ID | --rank RANK_ID] [-g GROUP_ID | --group GROUP_ID] [-t THREAD_INDEX | --thread THREAD_INDEX] [-c | --condition] [-i | --ignore-count]
```
- 删除断点:
```shell
breakpoint delete [-h | --help] [-n BREAKPOINT_ID | --number BREAKPOINT_ID] [-a | --all] [-r RANK_ID | --rank RANK_ID] [-g GROUP_ID | --group GROUP_ID] [-t THREAD_INDEX | --thread THREAD_INDEX]
```
- 查看断点:
```shell
breakpoint list [-h | --help] [-r RANK_ID | --rank RANK_ID] [-g GROUP_ID | --group GROUP_ID] [-t THREAD_INDEX | --thread THREAD_INDEX]
```
```text
[说明]
breakpoint命令可简写为b、break。
```

#### 参数说明
**表1 set命令参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-f/--file</td>
    <td>LAUNCH_TYPE</td>
    <td>
      必选参数，指定调试源码文件路径。
    </td>
  </tr>
  <tr>
    <td>-l/--line</td>
    <td>APP_WORKLOAD</td>
    <td>
      必选参数，指定文件中断点所在行。
    </td>
  </tr>
  <tr>
    <td>-r/--rank</td>
    <td>RANK_ID</td>
    <td>
      指定rank ID。
    </td>
  </tr>
  <tr>
    <td>-g/--group</td>
    <td>GROUP_ID</td>
    <td>
      指定group ID。<br>
      [说明] 在Attach模式下不支持使用-g/--group参数。
    </td>
  </tr>
  <tr>
    <td>-t/--thread</td>
    <td>THREAD_INDEX</td>
    <td>
     指定线程索引。
    </td>
  </tr>
  <tr>
    <td>-c/--condition</td>
    <td>CONDITION</td>
    <td>
      指定条件断点表达式。<br>
      例如：x>10
    <td>
  </tr>
  <tr>
    <td>-i/--ignore-count</td>
    <td>IGNORE_COUNT</td>
    <td>
      指定条件断点命中忽略次数。<br>
      例如：2
    </td>
  </tr>
  <tr>
    <td>-p/--port</td>
    <td>RPC_SERVER_PORT</td>
    <td>
      必选参数，Agent Server运行端口号，设置后用于上报启动信息。
    </td>
  </tr>
  <tr>
    <td>-n/--thread</td>
    <td>THREAD_NUMS</td>
    <td>
      输入的OpenMP应用thread数量。
    </td>
  <tr>
</table>

**表2 delete命令参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-n/--number</td>
    <td>BREAKPOINT_ID</td>
    <td>
      指定需要删除的断点ID，与-a参数冲突。
    </td>
  </tr>
  <tr>
    <td>-a/--all</td>
    <td>--</td>
    <td>
      删除全部断点，与-n参数冲突。
    </td>
  </tr>
  <tr>
    <td>-r/--rank</td>
    <td>RANK_ID</td>
    <td>
      指定rank ID。
    </td>
  </tr>
  <tr>
    <td>-g/--group</td>
    <td>GROUP_ID</td>
    <td>
      指定group ID。<br>
      [说明] 在Attach模式下不支持使用-g/--group参数。
    </td>
  </tr>
  <tr>
    <td>-t/--thread</td>
    <td>THREAD_INDEX</td>
    <td>
     指定线程索引。
    </td>
  </tr>
</table>

**表3 list命令参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-r/--rank</td>
    <td>RANK_ID</td>
    <td>
      指定rank ID。
    </td>
  </tr>
  <tr>
    <td>-g/--group</td>
    <td>GROUP_ID</td>
    <td>
      指定group ID。<br>
      [说明] 在Attach模式下不支持使用-g/--group参数。
    </td>
  </tr>
  <tr>
    <td>-t/--thread</td>
    <td>THREAD_INDEX</td>
    <td>
     指定线程索引。
    </td>
  </tr>
</table>

#### 使用示例

执行以下命令，查看断点支持的功能信息：
```shell
(kpdb) breakpoint -h
```
结果回显
```shell
The most commonly used breakpoint(b/break) sub commands are:
   set                 Adds breakpoints.
   list                Views breakpoints.
   delete              Deletes breakpoints.

 See 'breakpoint(b/break) COMMAND -h/--help' for more information on a specific command.

```

### 9.3.2 variable变量命令

#### 命令功能

- 修改、获取、查看变量。

#### 命令格式

- 修改变量：
```shell
variable set [-h | --help] {-n VARIABLE_NAME | --name VARIABLE_NAME} {-v VARIABLE_VALUE | --value VARIABLE_VALUE} [-r RANK_ID | --rank RANK_ID]
```
- 获取变量：
```shell
variable get [-h | --help] {-n VARIABLE_NAME | --name VARIABLE_NAME} [-r RANK_ID | --rank RANK_ID]
```
- 查看变量：
```shell
variable list [-h | --help] [-r RANK_ID | --rank RANK_ID]
```
```text
[说明]
variable命令可简写为v、var。
```

#### 参数说明
**表1 set命令参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-n/--name</td>
    <td>VARIABLE_NAME</td>
    <td>
      必选参数，指定变量名。
    </td>
  </tr>
  <tr>
    <td>-v/--value</td>
    <td>VARIABLE_VALUE</td>
    <td>
      必选参数，指定变量值。
    </td>
  </tr>
  <tr>
    <td>-r/--rank</td>
    <td>RANK_ID</td>
    <td>
      指定rank ID。
    </td>
  </tr>
</table>

**表2 get命令参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-n/--name</td>
    <td>VARIABLE_NAME</td>
    <td>
      必选参数，指定变量名。
    </td>
  </tr>
  <tr>
    <td>-r/--rank</td>
    <td>RANK_ID</td>
    <td>
      指定rank ID。
    </td>
  </tr>
</table>

**表3 list命令参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-r/--rank</td>
    <td>RANK_ID</td>
    <td>
      指定rank ID。
    </td>
  </tr>
</table>

#### 使用示例

执行以下命令，查看变量支持的功能信息：
```shell
(kpdb) variable -h
```
结果回显
```shell
The most commonly used variable(v) sub commands are:
   list                Displays all variables of the specified rank. (The nested content of complex variables is not displayed.)
   set                 Sets a variable value of the specified rank.
   get                 Obtains the variable value of the specified rank.

 See 'variable(v/var) COMMAND -h/--help' for more information on a specific command.

```

### 9.3.3 stack堆栈命令

#### 命令功能

- 查看堆栈信息，设置栈帧。

#### 命令格式

- 查看堆栈信息：
```shell
stack info [-h | --help] [-r RANK_ID | --rank RANK_ID] [-t THREAD_INDEX | --thread THREAD_INDEX]
```
- 切换栈帧：
```shell
stack select [-h | --help] {-f FRAME_INDEX | --frame FRAME_INDEX} [-r RANK_ID | --rank RANK_ID]
```
```text
[说明]
stack命令可简写为s、stk。
```

#### 参数说明
**表1 info命令参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-r/--rank</td>
    <td>RANK_ID</td>
    <td>
      指定rank ID。
    </td>
  </tr>
  <tr>
    <td>-t/--thread</td>
    <td>THREAD_INDEX</td>
    <td>
     指定线程索引。
    </td>
  </tr>
</table>

**表2 get命令参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-r/--rank</td>
    <td>RANK_ID</td>
    <td>
      指定rank ID。
    </td>
  </tr>
  <tr>
    <td>-f/--frame</td>
    <td>FRAME_INDEX</td>
    <td>
     指定栈帧ID。
    </td>
  </tr>
</table>

#### 使用示例

执行以下命令，查看堆栈支持的功能信息：
```shell
(kpdb) stack -h
```
结果回显
```shell
The most commonly used stack(s/stk) sub commands are:
   info                Displays the stack information of the specified thread.
   select              Switch between stack frames of the specified thread.

See 'stack(s/stk) COMMAND -h/--help' for more information on a specific command.

```

### 9.3.4 register寄存器变量命令

#### 命令功能

- 查看单个/全部寄存器变量信息、设置寄存器变量值。

#### 命令格式

- 查看单个寄存器变量：
```shell
register get [-h | --help] {-n REGISTER_NAME | --name REGISTER_NAME} [-r RANK_ID | --rank RANK_ID]
```
- 查看全部寄存器变量：
```shell
register list [-h | --help] [-r RANK_ID | --rank RANK_ID]
```
- 设置寄存器变量值：
```shell
register set [-h | --help] {-n REGISTER_NAME | --name REGISTER_NAME} {-v REGISTER_VALUE | --value REGISTER_VALUE} [-r RANK_ID | --rank RANK_ID]
```
```text
[说明]
register命令可简写为re、reg。
```

#### 参数说明
**表1 get命令参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-n/--name</td>
    <td>VARIABLE_NAME</td>
    <td>
      必选参数，指定寄存器变量名。
    </td>
  </tr>
  <tr>
    <td>-r/--rank</td>
    <td>RANK_ID</td>
    <td>
      指定rank ID。
    </td>
  </tr>
</table>

**表2 list命令参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-r/--rank</td>
    <td>RANK_ID</td>
    <td>
      指定rank ID。
    </td>
  </tr>
</table>

**表3 list命令参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-n/--name</td>
    <td>VARIABLE_NAME</td>
    <td>
      必选参数，指定寄存器变量名。
    </td>
  </tr>
  <tr>
    <td>-v/--value</td>
    <td>VARIABLE_VALUE</td>
    <td>
      必选参数，指定寄存器变量值。
    </td>
  </tr>
  <tr>
    <td>-r/--rank</td>
    <td>RANK_ID</td>
    <td>
      指定rank ID。
    </td>
  </tr>
</table>

#### 使用示例

执行以下命令，查看变量支持的功能信息：
```shell
(kpdb) register -h
```
结果回显
```shell
The most commonly used register(reg) sub commands are:
   list                Displays all registers of the specified rank.
   set                 Sets a register value of the specified rank.
   get                 Obtains the register value of the specified rank.

 See 'register(re/reg) COMMAND -h/--help' for more information on a specific command.

```

### 9.3.5 rank命令

#### 命令功能

- 查看单个/全部rank信息、设置调试作用范围。

#### 命令格式

- 查看单个rank信息：
```shell
rank info [-h | --help] RANK_ID
```
- 查看全部rank信息：
```shell
rank list [-h | --help]
```
- 设置调试作用范围：
```shell
rank set [-h | --help] RANK_ID
```
```text
[说明]
rank命令可简写为r，例如：r info 0
```

#### 使用示例

执行以下命令，查看rank支持的功能信息：
```shell
(kpdb) rank -h
```
结果回显
```shell
The most commonly used rank(r) sub commands are:
   all                 Change the workspace to global.
   list                Displays all ranks.
   info                Displays the specified rank.
   set                 Specifies the currently operated rank.

 See 'rank(r) COMMAND -h/--help' for more information on a specific command.

```

### 9.3.6 group命令

#### 命令功能

- 查看单个/全部group信息、设置调试作用范围。

#### 命令格式

- 查看全部group信息：
```shell
group list [-h | --help]
```
- 设置调试作用范围：
```shell
group set [-h | --help] GROUP_ID
```
- 查看单个group信息：
```shell
group info [-h | --help] GROUP_ID
```
```text
[说明]
group命令可简写为g，例如：g info 1。
```

#### 使用示例

执行以下命令，查看group支持的功能信息：
```shell
(kpdb) group -h
```
结果回显
```shell
The most commonly used group(g) sub commands are:
   list                Displays all communication subgroups.
   info                Displays the specified communication subgroup.
   set                 Specifies the currently operated communication subgroup.

 See 'group(g) COMMAND -h/--help' for more information on a specific command.

```

### 9.3.7 thread命令

#### 命令功能

- 查看单个/全部thread信息、设置调试作用范围。

#### 命令格式

- 查看单个thread信息：
```shell
thread info [-h | --help] THREAD_INDEX
```
- 查看全部thread信息：
```shell
thread list [-h | --help]
```
- 设置调试作用范围：
```shell
thread set [-h | --help] THREAD_INDEX
```
```text
[说明]
thread命令可简写为t，例如：t info 1。
```

#### 使用示例

执行以下命令，查看thread支持的功能信息：
```shell
(kpdb) thread -h
```
结果回显
```shell
The most commonly used thread(t) sub commands are:
   list                Displays all threads in the current rank.
   info                Displays the specified thread in the current rank.
   set                 Specifies the currently operated thread.

 See 'thread(t) COMMAND -h/--help' for more information on a specific command.

```

### 9.3.8 list命令

#### 命令功能

- 展示当前程序暂停位置的前后若干行代码。

#### 命令格式

```shell
list [-h | --help] [-r RANK_ID | --rank RANK_ID] [-t THREAD_INDEX | --thread THREAD_INDEX] [-l LINE_NUMBER | --lines LINE_NUMBER]
```
```text
[说明]
list命令可简写为l。
```

#### 参数说明

**表1 list参数说明**
<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-r/--rank</td>
    <td>RANK_ID</td>
    <td>
      指定rank ID。
    </td>
  </tr>
  <tr>
    <td>-t/--thread</td>
    <td>THREAD_INDEX</td>
    <td>
      指定线程索引。
    </td>
  </tr>
  <tr>
    <td>-l/--lines</td>
    <td>LINE_NUMBER</td>
    <td>
      指定当前暂停位置前后代码行数。
    </td>
  </tr>
</table>

#### 使用示例

执行以下命令，查看list支持的功能信息：
```shell
(kpdb) list -h
```
结果回显
```shell
OVERVIEW
    Run this command to display the code context of the current pause location of the application.

USAGE
    list
    [-h | --help]
    [-r RANK_ID | --rank RANK_ID]
    [-l LINE_NUMBER | --line LINE_NUMBER]

OPTIONS
    -h, --help
    Get help information.

    -r, --rank RANK_ID
    Specifies the rank ID of the source code to be queried.

    -l, --line LINE_NUMBER
    Specifies the number of lines of code before and after the program pause position to be displayed.

EXAMPLE
    # Displays the 10 lines of code before and after the pause location of the rank 0 application.
    list -l 10 -r 0

```

## 9.4 调试动作命令

### 9.4.1 continue命令

#### 命令功能

- 继续执行程序直到遇到下一个断点或结束。

#### 命令格式

```shell
continue/c [-h | --help]
```
```text
[说明]
continue命令可简写为c。
```

#### 使用示例

执行以下命令，查看continue支持的功能信息：
```shell
(kpdb) continue -h
```
结果回显
```shell
OVERVIEW
    Run this command to execute the application to the next breakpoint or until the application ends.

USAGE
    continue/c
    [-h | --help]

OPTIONS
    -h, --help
    Get help information.

EXAMPLE
    # Executes the application to the next breakpoint or until the application ends.
    continue

```

### 9.4.2 next命令

#### 命令功能

- 执行当前行，跳到下一行代码（不进入函数内部）。

#### 命令格式

```shell
next/n [-h | --help]
```
```text
[说明]
next命令可简写为n。
```

#### 使用示例

执行以下命令，查看next支持的功能信息：
```shell
(kpdb) next -h
```
结果回显
```shell
OVERVIEW
    Run this command to execute the current line and jumps to the next line of code (without entering the function).

USAGE
    next/n
    [-h | --help]

OPTIONS
    -h, --help
    Get help information.

EXAMPLE
    # Executes the current line and jumps to the next line of code (without entering the function).
    next

```

### 9.4.3 step-in命令

#### 命令功能

- 执行当前行，若遇到函数调用则进入该函数内部。

#### 命令格式

```shell
step-in/si [-h | --help]
```
```text
[说明]
step-in命令可简写为si。
```

#### 使用示例

执行以下命令，查看step-in支持的功能信息：
```shell
(kpdb) step-in -h
```
结果回显
```shell
OVERVIEW
    Run this command to execute the current line. If a function is called, enter this function.

USAGE
    step-in/si
    [-h | --help]

OPTIONS
    -h, --help
    Get help information.

EXAMPLE
    # Executes the current line. If a function is called, enter this function.
    step-in

```

### 9.4.4 step-out命令

#### 命令功能

- 从当前函数内部执行完并返回到调用处。

#### 命令格式

```shell
step-out/so [-h | --help]
```
```text
[说明]
step-out命令可简写为so。
```

#### 使用示例

执行以下命令，查看step-out支持的功能信息：
```shell
(kpdb) step-out -h
```
结果回显
```shell
OVERVIEW
    Run this command to finish the execution in the function and returns to the calling location.

USAGE
    step-out/so
    [-h | --help]

OPTIONS
    -h, --help
    Get help information.

EXAMPLE
    # Finishes the execution in the function and returns to the calling location.
    step-out

```

### 9.4.5 pause命令

#### 命令功能

- 在程序运行时手动暂停执行。

#### 命令格式

```shell
pause/p [-h | --help]
```
```text
[说明]
pause命令可简写为p。
```

#### 使用示例

执行以下命令，查看pause支持的功能信息：
```shell
(kpdb) pause -h
```
结果回显
```shell
OVERVIEW
    Run this command to manually suspends the running application.

USAGE
    pause/p
    [-h | --help]

OPTIONS
    -h, --help
    Get help information.

EXAMPLE
    # Manually suspends the running application.
    pause

```

### 9.4.6 quit命令

#### 命令功能

- 立即终止调试会话退出程序。

#### 命令格式

```shell
quit/q [-h | --help]
```
```text
[说明]
quit命令可简写为q。
```

#### 使用示例

执行以下命令，查看quit支持的功能信息：
```shell
(kpdb) quit -h
```
结果回显
```shell
OVERVIEW
    Run this command to terminate the debugging session and exits the application immediately.

USAGE
    quit/q
    [-h | --help]

OPTIONS
    -h, --help
    Get help information.

EXAMPLE
    # Terminates the debugging session and exits the application immediately.
    quit

```

## 9.4 整体使用示例

- 简要示范全流程使用HPC调试器，从安装证书、启动程序到调试程序。

### 安装证书

- 若使用debugger工具，需先安装工具后再安装证书，安装完成后即可使用。这里以RPM包安装方式为例：
#### 步骤1 安装RPM包。

```shell
rpm -ivh devkit-x.x.x-1.aarch64.rpm devkit-debugger-x.x.x-1.aarch64.rpm
```
结果回显
```shell
Preparing...                          ################################# [100%]
Updating / installing...
   1:devkit-x.x.x-1                  ################################# [ 50%]
devkit installed
   2:devkit-debugger-x.x.x-1         ################################# [100%]
devkit-debugger installed

```

#### 步骤2 验证是否安装成功。

```shell
rpm -qa | grep devkit
```
结果回显
```shell
devkit-debugger-x.x.x-1.aarch64
devkit-x.x.x-1.aarch64

```

#### 步骤3 使自动补全命令生效。

```shell
source /etc/bash_completion.d/devkit.sh
```

#### 步骤4 安装证书。

```shell
cd /usr/local/devkit/debugger/
./install_rpc_cert
```

```text
[说明]
“/usr/local/”为工具默认安装路径。
若以TAR包方式安装工具，install_rpc_cert可执行文件在 “/Path_t o_Devkit_CLI/debugger/”路径下。“/Path_to_Devkit_CLI/”是DevKit命令行工具路径。
```

#### 步骤5 配置IP地址。

```shell
=== IP Selection ===

Available IP addresses:
1: xx.xx.xx.xx
2：xx.xx.xx.xx
3：xx.xx.xx.xx

Select IP [default 1]: 

Selected IP: xx.xx.xx.xx
The agent rpc certificate generated successfully.
```

#### 步骤6 查看rpc_cert目录结构。

```shell
ll rpc_cert
```
目录结构如下：
```shell
rpc_cert/
├── client.key             #服务端密钥（加密）
├── client_passwd          #服务端密钥解密的密码
│   ├── common
│   └── zeus
├── debugger_ca.pem       #根证书    
├── debugger_client.pem     #客户端证书
├── debugger_server.pem    #服务端证书
├── server.key             
└── server_passwd
    ├── common
    └── zeus
```

### 整体使用示例

“/home/test/mpi_demo.c”文件内容如下：

```shell
#include <stdlib.h>
#include <stdio.h>
#include <mpi.h>

int main(int argc, char **argv) {
    MPI_Init(NULL, NULL);

    // Get the rank and size in the original communicator
    int world_rank, world_size;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    int color = world_rank / 2; // Determine color based on row

    // Split the communicator based on the color and use the original rank for ordering
    MPI_Comm row_comm;
    MPI_Comm_split(MPI_COMM_WORLD, color, world_rank, &row_comm);

    int row_rank, row_size;
    MPI_Comm_rank(row_comm, &row_rank);
    MPI_Comm_size(row_comm, &row_size);

    printf("WORLD RANK/SIZE: %d/%d --- ROW RANK/SIZE: %d/%d\n",
           world_rank, world_size, row_rank, row_size);

    MPI_Comm_free(&row_comm);

    MPI_Finalize();
}
```

#### 步骤1 在启动程序前，需要对“mpi_demo.c”程序进行编译。

```shell
cd /home/test/
mpicc -g -o mpi_demo mpi_demo.c
```

#### 步骤2 以“/home/test/mpi_demo”文件为例进行HPC程序调试，启动程序。

```shell
devkit debugger -t launch -w /home/test/mpi_demo -s /home/test/ -m "mpirun --allow-run-as-root -np 4" -p 9982
```
程序启动后，进入到HPC调试器交互界面。

#### 步骤3 查看所有rank信息。

```shell
(kpdb) rank list
```
返回信息如下：
```shell
All ranks:
rank = 0, ip = xx.xx.xx.xx, pid = 14761
  file_name = /home/test/mpi_demo.c, location_line = 5, status: stopped, stopped_reason: breakpoint

rank = 1, ip = xx.xx.xx.xx, pid = 14762
  file_name = /home/test/mpi_demo.c, location_line = 5, status: stopped, stopped_reason: breakpoint

rank = 2, ip = xx.xx.xx.xx, pid = 14763
  file_name = /home/test/mpi_demo.c, location_line = 5, status: stopped, stopped_reason: breakpoint

rank = 3, ip = xx.xx.xx.xx, pid = 14764
  file_name = /home/test/mpi_demo.c, location_line = 5, status: stopped, stopped_reason: breakpoint
```

#### 步骤4 这里以rank 0为例，查看rank 0代码位置。

这里以rank 0为例，查看rank 0代码位置。
```shell
(kpdb) list -r 0 -l 10
```
返回信息如下：
```shell
      1 | #include <stdlib.h>
      2 | #include <stdio.h>
      3 | #include <mpi.h>
      4 | 
=>    5 | int main(int argc, char **argv) {
      6 |     MPI_Init(NULL, NULL);
      7 | 
      8 |     // Get the rank and size in the original communicator
      9 |     int world_rank, world_size;
     10 |     MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
     11 |     MPI_Comm_size(MPI_COMM_WORLD, &world_size);
     12 | 
     13 |     int color = world_rank / 2; // Determine color based on row
     14 | 
     15 |     // Split the communicator based on the color and use the original rank for ordering
```

#### 步骤5 在rank 0中进行变量操作。

1.查看所有变量信息。

```shell
(kpdb) variable list -r 0
```
返回信息如下：
```shell
(int) argc = 0
(char **) argv = 0x0000000000000000
(int) world_rank = 0
(int) world_size = 0
(int) color = 0
(MPI_Comm) row_comm = 0x0000ffffbe241594
(int) row_rank = 65535
(int) row_size = -8064
```

2.查看row_comm.c_name变量信息。

```shell
(kpdb) variable get -n row_comm.c_name -r 0
```
返回信息如下：
```shell
└── (char[64]) c_name = {'\xf3', '\n', '\0', '\xd0', 's', '*', 'G', '\xf9', '\x14', '\v'}
    ├── (char) [0] = '\xf3'
    ├── (char) [1] = '\n'
    ├── (char) [2] = '\0'
    ├── (char) [3] = '\xd0'
    ├── (char) [4] = 's'
    ├── (char) [5] = '*'
    ├── (char) [6] = 'G'
    ├── (char) [7] = '\xf9'
    ├── (char) [8] = '\x14'
    ├── (char) [9] = '\v'
```

3.修改color变量信息。

```shell
(kpdb) variable set -n color -v 4 -r 0
```
返回信息如下：
```shell
The variable color is set to 4 successfully
```
查看修改后的color变量。
```shell
(kpdb) variable get -n color -r 0
```
返回信息如下：
```shell
(int) color = 4
```
```text
[说明]
对于复杂变量的嵌套成员，输入变量名时用小数点（.）隔开，例如：row_comm.c_name。
```

#### 步骤6 查看rank 0堆栈信息。

1.查看堆栈信息。
```shell
(kpdb) stack info -r 0
```
返回信息如下：
```shell
All stack frames of thread 1 in rank 0:

   frame_index = 0, address = 0x0000000000400aa0, file_name = /home/test/mpi_demo.c, function_name = main, line_num = 5, 'selected' = True
```

2.切换栈帧。
```shell
(kpdb) stack select -f 0 -r 0
```
返回信息如下：
```shell
The frame index of rank 0 is successfully set to 0.
```

#### 步骤7 在rank 0中进行断点操作。

1.设置断点。
```shell
(kpdb) breakpoint set -f /home/test/mpi_demo.c -l 6
(kpdb) breakpoint set -f /home/test/mpi_demo.c -l 20
```

2.查看断点
```shell
(kpdb) breakpoint list -r 0
```
返回信息如下：
```shell
Current breakpoints:
breakpoint_id = 2: file_name = mpi_demo.c, locations = 1
  location_line = 6, address = mpi_demo[0x0000000000400ab0], condition = , hit_count = 0, ignore_count = 0, thread = 4294967295
breakpoint_id = 3: file_name = mpi_demo.c, locations = 1
  location_line = 20, address = mpi_demo[0x0000000000400abc], condition = , hit_count = 0, ignore_count = 0, thread = 4294967295
```

3.删除断点。
```shell
(kpdb) breakpoint delete -n 2 -r 0
(kpdb) breakpoint list -r 0
```
返回信息如下：
```shell
Current breakpoints:
breakpoint_id = 3: file_name = mpi_demo.c, locations = 1
  location_line = 20, address = mpi_demo[0x0000000000400abc], condition = , hit_count = 0, ignore_count = 0, thread = 4294967295
```

#### 步骤8 调试程序。

1.使用next命令执行到下一行。
```shell
(kpdb) next
(kpdb) list -r 0
```
返回信息如下：
```shell
      1 | #include <stdlib.h>
      2 | #include <stdio.h>
      3 | #include <mpi.h>
      4 | 
      5 | int main(int argc, char **argv) {
=>    6 |     MPI_Init(NULL, NULL);
      7 | 
      8 |     // Get the rank and size in the original communicator
      9 |     int world_rank, world_size;
     10 |     MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
     11 |     MPI_Comm_size(MPI_COMM_WORLD, &world_size);
```

2.使用continue命令继续执行程序直到遇到下一个断点或结束。
```shell
(kpdb) continue
(kpdb) list -r 0
```
返回信息如下：
```shell
     15 |     // Split the communicator based on the color and use the original rank for ordering
     16 |     MPI_Comm row_comm;
     17 |     MPI_Comm_split(MPI_COMM_WORLD, color, world_rank, &row_comm);
     18 | 
     19 |     int row_rank, row_size;
=>   20 |     MPI_Comm_rank(row_comm, &row_rank);
     21 |     MPI_Comm_size(row_comm, &row_size);
     22 | 
     23 |     printf("WORLD RANK/SIZE: %d/%d --- ROW RANK/SIZE: %d/%d\n",
     24 |            world_rank, world_size, row_rank, row_size);
     25 |
```

#### 步骤9 查看group信息。

1.查看所有group信息。
```shell
(kpdb) group list
```
返回信息如下：
```shell
All subgroups:
  subgroup 1: contain_ranks = [2, 3]
  subgroup 2: contain_ranks = [0, 1]
```

2.查看group 1信息。
```shell
(kpdb) group info 1
```
返回信息如下：
```shell
All ranks in group 1:
rank = 2, ip = xx.xx.xx.xx, pid = 14763
  file_name = /home/test/mpi_demo.c, location_line = 20, status: stopped, running_status = 2, stopped_reason: breakpoint

rank = 3, ip = xx.xx.xx.xx, pid = 14764
  file_name = /home/test/mpi_demo.c, location_line = 20, status: stopped, running_status = 2, stopped_reason: breakpoint
```

#### 步骤10 退出程序。

```shell
(kpdb) quit
```
返回信息如下：
```shell
Start to stop debugger task.
Successfully stopped debugger task.
```

# 10 JVM性能波动诊断
### 10.1 命令功能
JVM性能波动诊断工具监测Java应用的Code Cache、JIT Compiler指标，发现导致性能波动的异常指标后，给出指标异常告警；在异常发生前，自动收集更细粒度的诊断数据，并支持离线分析；用户可通过工具分析诊断数据，找出导致Code Cache 、JIT退优化异常的原因。

命令格式：
```shell
devkit diag [-h | --help] TASK [ARGS]
```
示例均为RPM包安装使用。 JIT退优化监测仅支持毕昇JDK17和毕昇JDK嫁接版本。

使用示例执行以下命令，查看JVM性能波动诊断工具支持的功能信息：
```shell
devkit diag -h
```
返回信息如下：
```shell
 Usage: devkit diag [-h | --help] TASK [ARGS]

 The most commonly used devkit diag sub tasks are:
   help         Get help information
   jvm-jitter   Run the JVM performance collection and diagnosis task

 See 'devkit diag TASK --help' for more information on a specific task.
```

### 10.2 监测分析Java应用
命令功能可使用监测模式和分析模式对Java应用进行诊断分析。

命令格式：

监测模式:实时监测Java进程发生的事件。

```shell
devkit diag jvm-jitter [-h | --help] {-a monitor | --action monitor} {-e EVENT | --event EVENT} [-c | config] {-p PID | --pid PID}
```

分析模式:根据采集到的JFR文件分析进程信息。

```shell
devkit diag jvm-jitter [-h | --help] {-a report | --action report} {-e EVENT | --event EVENT} {-f INPUT_FILE | --file INPUT_FILE} [-o OUTPUT_PATH | --output OUTPUT_PATH]
```

**表1 公共参数说明**

<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-h/--help</td>
    <td>--</td>
    <td>获取帮助信息。</td>
  </tr>
  <tr>
    <td>-a/--action</td>
    <td>monitor/report</td>
    <td>必选参数，指定JVM诊断工具的工作模式。monitor：指定为监测模式。report：指定为分析模式。开启jit.deoptimization退优化事件检测时会在工作目录（cfg文件指定）下生成'devkit_odin.properties'文件，需修改'MONITOR_JIT'为true开启监控</td>
  </tr>
  <tr>
    <td>-e/--event</td>
    <td>jit.deoptimization/codecache.full/all</td>
    <td>必选参数，指定需要监测或分析的事件名称，支持JIT退优化事件和CodeCache统计事件。monitor模式下all表示同时监测两个事件</td>
  </tr>
</table>

**表2 监测模式参数说明**

<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-p/--pid</td>
    <td>PID</td>
    <td>必选参数，指定监测的Java进程ID。</td>
  </tr>
  <tr>
    <td>-c/--config</td>
    <td>cfg file</td>
    <td>可选参数，指定配置文件，工具提供模板配置文件在工具目录下/Absolute-Path-to-DevKit-CLI/diag/config/kunpeng_devkit.cfg。</td>
  </tr>
</table>

**表3 分析模式参数说明**

<table>
  <tr>
    <th>参数</th>
    <th>参数选项</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>-f/--file</td>
    <td>input file</td>
    <td>必选参数，指定需要分析的JFR文件</td>
  </tr>
  <tr>
    <td>-o/--output</td>
    <td>output path</td>
    <td>可选参数，指定生成JFR退优化事件对应火焰图的路径，默认路径为/Absolute-Path-to-DevKit-CLI/diag/data。</td>
  </tr>
</table>

若工具目录为/home/DevKit-CLI-xx.xx.xx-Linux-Kunpeng，则配置文件的参考文件路径为/home/DevKit-CLI-xx.xx.xx-Linux-Kunpeng/diag/config/kunpeng_devkit.cfg。
校验文件见/home/DevKit-CLI-xx.xx.xx-Linux-Kunpeng/diag/config/kunpeng_devkit.xsd。

**表4 配置文件参数说明**

<table>
  <tr>
    <th>参数</th>
    <th>参数说明</th>
  </tr>
  <tr>
    <td>enabled</td>
    <td>是否开启指定事件的采集。</td>
  </tr>
  <tr>
    <td>period</td>
    <td>采样间隔，默认为1s。数字和单位以空格分隔，单位支持秒、分、时、天（s/m/h/d）。</td>
  </tr>
  <tr>
    <td>duration</td>
    <td>采样时长，默认为0s（数字为0表示一直采集）。数字和单位以空格分隔，单位支持秒、分、时、天（s/m/h/d）。</td>
  </tr>
  <tr>
    <td>jitTraceThreshold</td>
    <td>触发JIT事件细粒度采集的阈值，默认60（computeMode设置得出的计算值），取值范围大于0。</td>
  </tr>
  <tr>
    <td>jitCollectDuration</td>
    <td>每次触发JIT事件细粒度采集时的采样时长，默认10秒。</td>
  </tr>
  <tr>
    <td>computeMode</td>
    <td>设置采集阈值的计算方式，默认deoptimizationCount。可选：deoptimizationCount：仅以退优化增长数量计算；compileCount：以退优化增长数量和编译数量计算；addCount：以退优化增长数量和编译增长数量计算。</td>
  </tr>
  <tr>
    <td>jfrDirPath</td>
    <td>采集事件输出jfr文件的路径，会该目录下生成devkit_odin_jfr文件夹存放，若无权限则使用当前工作目录或/tmp目录</td>
  </tr>
  <tr>
    <td>totalJfrFileSize</td>
    <td>devkit_odin_jfr文件夹中此次采集所有JFR文件的大小限制，存放于命名为"Recording_监控开始时间"的子文件夹，0表示无限制，默认为200MB</td>
  </tr>
  <tr>
    <td>singleJfrFileSize</td>
    <td>采集到单个jfr文件的大小限制，单位为MB，0表示无限制，默认为12MB</td>
  </tr>
  <tr>
    <td>CompilerInlining</td>
    <td>添加方法内联事件采集，默认false。</td>
  </tr>
  <tr>
    <td>Compilation</td>
    <td>添加编译事件采集，默认false。</td>
  </tr>
  <tr>
    <td>CompilationFailure</td>
    <td>添加编译失败事件采集，默认false。</td>
  </tr>
  <tr>
    <td>CompilerConfiguration</td>
    <td>添加编译配置事件采集，默认false。</td>
  </tr>
  <tr>
    <td>CompilerPhase</td>
    <td>添加编译阶段事件采集，默认false。</td>
  </tr>
  <tr>
    <td>JITRestart</td>
    <td>添加ReStart事件采集，默认false。</td>
  </tr>
  <tr>
    <td>codeCacheTraceThreshold</td>
    <td>触发CodeCache事件细粒度采集的阈值，默认0.35（CodeCache事件在全部事件中的占比），取值范围0-1。</td>
  </tr>
  <tr>
    <td>codeCacheAlarmThreshold</td>
    <td>触发CodeCache事件异常告警的阈值，默认0.75（CodeCache事件在全部事件中的占比），取值范围0-1。</td>
  </tr>
</table>

### 10.3 整体使用示例

#### 监测模式

```shell
devkit diag jvm-jitter -a monitor -e jit.deoptimization -c /home/DevKit-CLI-xx.xx.xx-Linux-Kunpeng/diag/config/kunpeng_devkit.cfg -p 1179
```

参数-a monitor指定为监测模式，参数-e jit.deoptimization指定监测的退优化事件，参数-c指定配置文件路径，参数-p 1179指定待监测Java进程的进程号，当前工作目录为/home/test/workspace/demo。
修改工作目录下的'devkit_odin.properties'文件，修改'MONITOR_JIT'为true来开启监控。
返回信息如下：

```shell
2025-04-11 15:18:29,173 INFO  [jvm-diagnosis-guardian-common-thread-1] c.h.k.devkit.odin.cli.CliWorker: UNIX socket connection established successfully
2025-04-11 15:18:29,287 INFO  [jvm-diagnosis-profiler-wireIo-thread-1] c.h.k.devkit.odin.cli.CliWorker: other type: CPU_JDBC_METHOD
2025-04-11 15:18:30,968 INFO  [jvm-diagnosis-profiler-wireIo-thread-1] c.h.k.devkit.odin.cli.CliWorker: other type: NONE
2025-04-11 15:18:32,000 INFO  [jvm-diagnosis-profiler-wireIo-thread-1] c.h.k.devkit.odin.cli.CliWorker: JVM_JIT_MONITOR: deoptimizationRatio=0.0, startTime=2025/04/11 PM 03:18:31.925, compileCount=2027, deoptimizationCount=30
2025-04-11 15:18:32,955 INFO  [jvm-diagnosis-profiler-wireIo-thread-1] c.h.k.devkit.odin.cli.CliWorker: JVM_JIT_MONITOR: deoptimizationRatio=5.0, startTime=2025/04/11 PM 03:18:32.925, compileCount=2241, deoptimizationCount=35
2025-04-11 15:18:33,927 INFO  [jvm-diagnosis-profiler-wireIo-thread-1] c.h.k.devkit.odin.cli.CliWorker: JVM_JIT_MONITOR: deoptimizationRatio=0.0, startTime=2025/04/11 PM 03:18:33.925, compileCount=2276, deoptimizationCount=35
2025-04-11 15:18:34,927 INFO  [jvm-diagnosis-profiler-wireIo-thread-1] c.h.k.devkit.odin.cli.CliWorker: JVM_JIT_MONITOR: deoptimizationRatio=0.0, startTime=2025/04/11 PM 03:18:34.926, compileCount=2280, deoptimizationCount=35
2025-04-11 15:18:35,927 INFO  [jvm-diagnosis-profiler-wireIo-thread-1] c.h.k.devkit.odin.cli.CliWorker: JVM_JIT_MONITOR: deoptimizationRatio=0.0, startTime=2025/04/11 PM 03:18:35.926, compileCount=2288, deoptimizationCount=35
...
```

查看目标进程侧输出或/tmp/用户名/devkit_odin_sdk.log.XX下的日志记录，采集到的jfr文件位于当前工作目录下devkit_odin_jfr的子文件夹"Recording_开启监控时间"内。

```shell
Apr 11, 2025 3:18:30 PM com.huawei.kunpeng.devkit.odin.monitor.JitCollector handleEnvVariableChange
INFO: JIT monitor begin
Apr 11, 2025 3:18:37 PM com.huawei.kunpeng.devkit.odin.monitor.JitCollector$JitCollectorInner dumpJfrFile
INFO: Dump jfr file: /home/test/workspace/demo/devkit_odin_jfr/Recording_20250411_151830_553/devkit_20250411_151832_925.jfr
Apr 11, 2025 3:19:24 PM com.huawei.kunpeng.devkit.odin.monitor.JitCollector$JitCollectorInner dumpJfrFile
INFO: Dump jfr file: /home/test/workspace/demo/devkit_odin_jfr/Recording_20250411_151830_553/devkit_20250411_151919_934.jfr
Apr 11, 2025 3:20:10 PM com.huawei.kunpeng.devkit.odin.monitor.JitCollector$JitCollectorInner dumpJfrFile
INFO: Dump jfr file: /home/test/workspace/demo/devkit_odin_jfr/Recording_20250411_151830_553/devkit_20250411_152001_944.jfr
Apr 11, 2025 3:20:11 PM com.huawei.kunpeng.devkit.odin.profiler.agent.ProfilerAgent deactivate
INFO: deactivate
Apr 11, 2025 3:20:11 PM com.huawei.kunpeng.devkit.odin.profiler.agent.ProfilerWorker terminate
INFO: terminate
Apr 11, 2025 3:20:11 PM com.huawei.kunpeng.devkit.odin.monitor.CodeCacheCollector disableMonitor
INFO: Disable codecache monitor
Apr 11, 2025 3:20:11 PM com.huawei.kunpeng.devkit.odin.monitor.JitCollector disableMonitor
INFO: Disable JIT monitor
Apr 11, 2025 3:20:11 PM com.huawei.kunpeng.devkit.odin.profiler.wire.WireIo receiveMessageInBatchOverBio
INFO: No message to parse.
Apr 11, 2025 3:20:11 PM com.huawei.kunpeng.devkit.odin.profiler.agent.ProfilerWorker heartbeatDetection
INFO: The UNIX socket connection is closed.
Apr 11, 2025 3:20:11 PM com.huawei.kunpeng.devkit.odin.profiler.agent.DefaultProfilerActivator deactivate
INFO: The profiling session is deactivated.
```

#### 分析模式

输入命令，-f指定为监测模式下得到的jfr文件：
```shell
devkit diag jvm-jitter -a report -e jit.deoptimization -f /home/test/workspace/demo/devkit_odin_jfr/Recording_20250411_151830_553/devkit_20250411_152001_944.jfr -o /home/test/data
```
参数-a report为指定为分析模式，参数-e jit.deoptimization指定分析退优化事件，参数-f指定待分析的jfr文件路径。

返回信息如下：
```shell
--------------------------------------------
Reason             Deoptimization methods
--------------------------------------------
loop_limit_check   1
unstable_if        10
class_check        12
-------------------------------------------
Action            Deoptimization methods
-------------------------------------------
maybe_recompile   13
reinterpret       10
-------------------------------------------------------------------------------------------------------------------------------------------------
Method                                                     Reason        Action        Instruction Line No.  Compiler  StartTime
-------------------------------------------------------------------------------------------------------------------------------------------------
java.io.BufferedReader.readLine(boolean, boolean[])        unstable_if   reinterpret   if_icmplt   330       c2        2025/04/11 PM 03:20:01.994
java.io.ByteArrayOutputStream.ensureCapacity(int)          unstable_if   reinterpret   ifle        99        c2        2025/04/11 PM 03:20:02.000
java.lang.StringLatin1.canEncode(int)                      unstable_if   reinterpret   ifne        54        c2        2025/04/11 PM 03:20:02.009
java.lang.StringBuffer.toString()                          unstable_if   reinterpret   ifeq        716       c2        2025/04/11 PM 03:20:02.462
org.json.JSONObject.isDecimalNotation(String)              unstable_if   reinterpret   if_icmpgt   2204      c2        2025/04/11 PM 03:20:02.469
org.json.JSONObject.isDecimalNotation(String)              unstable_if   reinterpret   if_icmpgt   2204      c2        2025/04/11 PM 03:20:02.469
org.json.JSONObject.writeValue(Writer, Object, int, int)   unstable_if   reinterpret   ifeq        2551      c2        2025/04/11 PM 03:20:02.510
org.json.JSONObject.writeValue(Writer, Object, int, int)   unstable_if   reinterpret   ifeq        2551      c2        2025/04/11 PM 03:20:02.867
test02.App.deserializeJson(String)                         unstable_if   reinterpret   if_icmpge   66        c2        2025/04/11 PM 03:20:05.149
test02.App.serializeJson(List)                             unstable_if   reinterpret   ifeq        93        c2        2025/04/11 PM 03:20:05.401
2025-04-11 15:26:16,419 INFO  [main] c.h.k.d.o.c.r.JitDeoptimizationReport: The above methods support disabling method-level branch prediction to eliminate deoptimization. Usage: -XX:CompileCommand=dontprediction,methodName
2025-04-11 15:26:16,620 INFO  [main] c.h.k.d.o.cli.report.JfrToFlameGraph: The generated flame graph is: /home/test/data/FlameGraph_devkit_20250411_152001_944_20250411152616.html
```

**表5 报告参数说明**

<table>
  <tr>
    <th>报告参数</th>
    <th>说明</th>
  </tr>
  <tr>
    <td>Method</td>
    <td>触发退优化的方法名称。</td>
  </tr>
  <tr>
    <td>Reason</td>
    <td>触发退优化的原因。unstable_if为分支预测失效，可使用参数"-XX:CompileCommand=dontprediction,methodName"进行方法级分支预测禁用，让指定的函数不产生unstable_if类型的退优化。</td>
  </tr>
  <tr>
    <td>Action</td>
    <td>JVM针对退优化采取的具体操作，例如：Maybe_Recompile：触发方法重新编译（可能更换编译器）。Invalidate：使当前编译的代码无效，回退到解释器模式执行。reinterpret：重新解析方法调用目标。</td>
  </tr>
  <tr>
    <td>Instruction</td>
    <td>触发退优化的字节码指令。</td>
  </tr>
  <tr>
    <td>Line No.</td>
    <td>触发退优化的Java源码行号。</td>
  </tr>
  <tr>
    <td>Compilers</td>
    <td>涉及退优化的编译器类型，例如：C1（Client Compiler）：快速编译，轻度优化。C2（Server Compiler）：深度优化，适合长期运行代码。</td>
  </tr>
</table>