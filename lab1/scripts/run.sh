script_path=`readlink -f $0` 
script_name=`basename $script_path`
script_dir=`dirname $script_path`

module_dir=$script_dir/.. 
module_dir=`readlink -f $module_dir`

root_dir=$script_dir/../.. 
root_dir=`readlink -f $root_dir`
root_name=`basename $root_dir`

## Cоздание и переход рабочую папку  
mkdir -p ${module_dir}/run
cd ${module_dir}/run

## Выбор режима gui
GUI="+gui"
while [ -n "$1" ]
do
    case "$1" in 
        -nogui) GUI=; ;;
    esac
    shift 1
done

## Определение входных параметров 
top_name='top_tb'

# FILES="-f <NAME>.f"
FILES=" ${root_dir}/lab1/data/rtl/counter/counter_tb.sv"
FILES+=" ${root_dir}/lab1/data/rtl/counter/counter.sv"

PARAMS="-access +rw -clean -seed random -disable_sem2009 -timescale 1ns/1ps

"

## Проверка  
echo "
root_dir: ${root_dir}
module_dir:${module_dir}
GUI: ${GUI}
top_name: ${top_name}
FILES: ${FILES}
PARAMS: ${PARAMS}
"
## Запуск xcelium 
xrun ${PARAMS} ${GUI} ${FILES} -top ${top_name}





