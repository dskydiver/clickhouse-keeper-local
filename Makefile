BASE_CONFIG_DIR := ./configs
GEN_CONFIG_DIR := ${BASE_CONFIG_DIR}/gen

.PHONY: gen-clickhouse-config
gen-clickhouse-config:
	rm -rf ${GEN_CONFIG_DIR} ; \
	mkdir -p ${GEN_CONFIG_DIR}/clickhouse-1 ; \
	mkdir -p ${GEN_CONFIG_DIR}/clickhouse-2

	SERVER_ID=1 envsubst < ${BASE_CONFIG_DIR}/enable_keeper.xml > ${GEN_CONFIG_DIR}/clickhouse-1/enable_keeper.xml
	REPLICA=r1 SHARD=blue envsubst < ${BASE_CONFIG_DIR}/macros.xml > ${GEN_CONFIG_DIR}/clickhouse-1/macros.xml
	cp ${BASE_CONFIG_DIR}/remote_servers.xml ${BASE_CONFIG_DIR}/use_keeper.xml ${BASE_CONFIG_DIR}/docker_related_config.xml ${GEN_CONFIG_DIR}/clickhouse-1/

	SERVER_ID=2 envsubst < ${BASE_CONFIG_DIR}/enable_keeper.xml > ${GEN_CONFIG_DIR}/clickhouse-2/enable_keeper.xml
	REPLICA=r2 SHARD=blue envsubst < ${BASE_CONFIG_DIR}/macros.xml > ${GEN_CONFIG_DIR}/clickhouse-2/macros.xml
	cp ${BASE_CONFIG_DIR}/remote_servers.xml ${BASE_CONFIG_DIR}/use_keeper.xml ${BASE_CONFIG_DIR}/docker_related_config.xml ${GEN_CONFIG_DIR}/clickhouse-2/

.PHONY: up
up:
	docker-compose up -d

.PHONY: keeper-check
keeper-check:
	echo ruok | nc 127.0.0.1 9181
