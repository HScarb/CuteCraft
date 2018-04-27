# ActorManager.gd
# 演算体管理器，负责注册演算体
extends Node

var arr_actor = []

signal unit_birth(unit_type_name, unit)     # 单位创建消息.单位类型名称(Marine)，单位实体

func _ready():
    # 根据路径加载演算体
    # *** 之后换成自动加载
    arr_actor.append(self._instance_actor("ActorUnitMarine"))
    # 初始化所有演算体
    for actor in arr_actor:
        actor.init()

func _get_actor_full_path(actor_name):
    return "res://scenes/Actor/%s.tscn" % actor_name

func _instance_actor(actor_name):
    return load(self._get_actor_full_path(actor_name)).instance()