# ActorManager.gd
# 演算体管理器，负责注册演算体
extends Node

var arr_actor = []

func _ready():
    # 根据路径加载演算体
    auto_add_actors()
    # 初始化所有演算体
    for actor in arr_actor:
        actor.init()

# 传入演算体名称，返回演算体全路径
func _get_actor_full_path(actor_name):
    return "%s%s" % [Global.ACTOR_DIR, actor_name]

# 根据演算体名称实例化演算体
func _instance_actor(actor_name):
    return load(self._get_actor_full_path(actor_name)).instance()

# 根据名称向演算体管理器中添加演算体
func add_actor_by_name(actor_name):
    self.arr_actor.append(self._instance_actor(actor_name))

func auto_add_actors():
    var path = Global.ACTOR_DIR
    var dir = Directory.new()
    if dir.open(path) == OK:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while (file_name != ""):
            if dir.current_is_dir():
                pass
            else:
                add_actor_by_name(file_name)
            file_name = dir.get_next()
    else:
        print("An error occurred when trying to access the path.")
    