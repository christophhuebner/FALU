.PHONY: adiv alu falu librelane clean

div:
	make -f div_test.mk

alu:
	make -f alu_test.mk

falu:
	make -f falu_test.mk

librelane-macro:
	make -f make_libre.mk macro

librelane-macro-openroad:
	make -f make_libre.mk macro-openroad

i2c:
	make -f i2c_test.mk
clean:
	make -f div_test.mk clean
	make -f alu_test.mk clean
	make -f falu_test.mk clean
	make -f make_libre.mk clean
