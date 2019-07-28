#
# Makefile
#

# Makefile の変数の宣言メモ
# = は､使われる際に代入される
# =: は､即時代入される

# SCEARIONAME が空ではない場合は､ true
ifdef SCEARIONAME
	# SCEARIONAME が空ではない場合は､ vagrant で実行
	SCEARIONAME := vagrant
else
	# SCEARIONAME 空の場合(default)の場合は､false
	# SCEARIONAME が空の場合は､ Docker で実行
	DOCKROPTION := run --rm -it
	MOUNT1 := "${PWD}":/tmp/$(basename "${PWD}"):ro
	MOUNT2 := /var/run/docker.sock:/var/run/docker.sock
	WORKDIR := /tmp/$(basename "${PWD}")
	DOCKERIMAGE := quay.io/ansible/molecule:2.20.2
	DOCKERCMD := docker $(DOCKROPTION) -v $(MOUNT1) -v $(MOUNT2) -w $(WORKDIR) $(DOCKERIMAGE)
	SCEARIONAME := docker
endif

# debugモードを on にしたい場合は､引数に下記を追加する
# DEBUG=--debug
DEBUG := --no-debug
ENVFILE := ./molecule/shared/.env.yml
CONFIG := ./molecule/$(SCEARIONAME)/molecule.yml
# 即代入だと､$MOLECULESUBCMD が未定義なのでエラーになる
MOLECULECMD = molecule --base-config $(CONFIG) --env-file $(ENVFILE) $(DEBUG) $(MOLECULESUBCMD) --scenario-name $(SCEARIONAME)

# test 関連のファイルを role 配下から playbookのテストフォルダ配下に移動
# もっとスマートな方法を調べたがなかったので苦肉の策として実施している
CPCMD := cp ./roles/*/molecule/shared/tests/test*.yml ./molecule/shared/tests/
# 作業後は不要なので削除する
RMCMD := rm -f `find molecule/shared/tests -name test_*.yml -not -name test_front-server.yml`

test:
	@${CPCMD}
	@$(eval MOLECULESUBCMD := test)
	@$(DOCKERCMD) $(MOLECULECMD)
	@$(RMCMD)

lint:
	@${CPCMD}
	@$(eval MOLECULESUBCMD := lint)
	@$(DOCKERCMD) $(MOLECULECMD)

cleanup:
	@${CPCMD}
	@$(eval MOLECULESUBCMD := cleanup)
	@$(DOCKERCMD) $(MOLECULECMD)

destroy:
	@${CPCMD}
	@$(eval MOLECULESUBCMD := destroy)
	@$(DOCKERCMD) $(MOLECULECMD)

dependency:
	@${CPCMD}
	@$(eval MOLECULESUBCMD := dependency)
	@$(DOCKERCMD) $(MOLECULECMD)

create:
	@${CPCMD}
	@$(eval MOLECULESUBCMD := create)
	@$(DOCKERCMD) $(MOLECULECMD)
	@$(RMCMD)

converge:
	@${CPCMD}
	@$(eval MOLECULESUBCMD := converge)
	@$(DOCKERCMD) $(MOLECULECMD)

verify:
	@${CPCMD}
	@$(eval MOLECULESUBCMD := verify)
	@$(DOCKERCMD) $(MOLECULECMD)
	@$(RMCMD)
