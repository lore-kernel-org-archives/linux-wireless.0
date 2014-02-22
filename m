Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:59731 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbaBVHkG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Feb 2014 02:40:06 -0500
Received: from [192.168.1.221] ([93.218.100.117]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0Lw1vh-1XKNSw03jB-017pH6 for
 <linux-wireless@vger.kernel.org>; Sat, 22 Feb 2014 08:40:04 +0100
Message-ID: <5308544D.4090507@rempel-privat.de> (sfid-20140222_084012_664940_B3F87942)
Date: Sat, 22 Feb 2014 08:39:57 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Greg Ketell <greg@ketell.com>, linux-wireless@vger.kernel.org,
	ilw@linux.intel.com
Subject: Re: Help with Intel 7260 on Debian Stable (wheezy)
References: <3815E3D1-0BFD-480D-B2C4-3405B08D5C0D@ketell.com>
In-Reply-To: <3815E3D1-0BFD-480D-B2C4-3405B08D5C0D@ketell.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dMMbma0St51hp8JS9riRjHwBlEii2qbp4"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dMMbma0St51hp8JS9riRjHwBlEii2qbp4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Fallow this link:

https://askubuntu.com/questions/331667/no-wireless-for-intel-corporation-=
7260-version-63

Am 22.02.2014 02:50, schrieb Greg Ketell:
> Hi folks,
>=20
> I=E2=80=99m trying to get the Intel 7260 working on Debian 7.4 (Kernel =
3.2) running on a Giga-Byte GB-BXi5-4200.   The standard iwlwifi for whee=
zy doesn=E2=80=99t have support for the 7260 so I=E2=80=99ve installed th=
e iwlwifi from debian-backports which lists that card as supported.  Unfo=
rtunately the card will not be recognized.
>=20
> # uname -a
> Linux Brix1 3.2.0-4-amd64 #1 SMP Debian 3.2.54-2 x86_64 GNU/Linux
>=20
> # lspci -nnk
> 00:00.0 Host bridge [0600]: Intel Corporation Haswell-ULT DRAM Controll=
er [8086:0a04] (rev 09)
> 	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5000]
> 00:02.0 VGA compatible controller [0300]: Intel Corporation Haswell-ULT=
 Integrated Graphics Controller [8086:0a16] (rev 09)
> 	Subsystem: Gigabyte Technology Co., Ltd Device [1458:d000]
> 00:03.0 Audio device [0403]: Intel Corporation Haswell-ULT HD Audio Con=
troller [8086:0a0c] (rev 09)
> 	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5000]
> 	Kernel driver in use: snd_hda_intel
> 00:14.0 USB controller [0c03]: Intel Corporation Lynx Point-LP USB xHCI=
 HC [8086:9c31] (rev 04)
> 	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5004]
> 	Kernel driver in use: xhci_hcd
> 00:16.0 Communication controller [0780]: Intel Corporation Lynx Point-L=
P HECI #0 [8086:9c3a] (rev 04)
> 	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5001]
> 00:1b.0 Audio device [0403]: Intel Corporation Lynx Point-LP HD Audio C=
ontroller [8086:9c20] (rev 04)
> 	Subsystem: Gigabyte Technology Co., Ltd Device [1458:fa50]
> 	Kernel driver in use: snd_hda_intel
> 00:1c.0 PCI bridge [0604]: Intel Corporation Lynx Point-LP PCI Express =
Root Port 1 [8086:9c10] (rev e4)
> 	Kernel driver in use: pcieport
> 00:1c.2 PCI bridge [0604]: Intel Corporation Lynx Point-LP PCI Express =
Root Port 3 [8086:9c14] (rev e4)
> 	Kernel driver in use: pcieport
> 00:1c.3 PCI bridge [0604]: Intel Corporation Lynx Point-LP PCI Express =
Root Port 4 [8086:9c16] (rev e4)
> 	Kernel driver in use: pcieport
> 00:1d.0 USB controller [0c03]: Intel Corporation Lynx Point-LP USB EHCI=
 #1 [8086:9c26] (rev 04)
> 	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5004]
> 	Kernel driver in use: ehci_hcd
> 00:1f.0 ISA bridge [0601]: Intel Corporation Lynx Point-LP LPC Controll=
er [8086:9c43] (rev 04)
> 	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5001]
> 00:1f.2 SATA controller [0106]: Intel Corporation Lynx Point-LP SATA Co=
ntroller 1 [AHCI mode] [8086:9c03] (rev 04)
> 	Subsystem: Gigabyte Technology Co., Ltd Device [1458:b002]
> 	Kernel driver in use: ahci
> 00:1f.3 SMBus [0c05]: Intel Corporation Lynx Point-LP SMBus Controller =
[8086:9c22] (rev 04)
> 	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5001]
> 02:00.0 Network controller [0280]: Intel Corporation Wireless 7260 [808=
6:08b1] (rev 73)
> 	Subsystem: Intel Corporation Dual Band Wireless-AC 7260 [8086:4070]
> 03:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL=
8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 0=
c)
> 	Subsystem: Gigabyte Technology Co., Ltd Motherboard [1458:e000]
> 	Kernel driver in use: r8169
>=20
> root@Brix1:/home/gketell# modprobe -r iwlwifi
> root@Brix1:/home/gketell# modprobe -vvv !$
> modprobe -vvv iwlwifi
> libkmod: DEBUG ../libkmod/libkmod-module.c:519 kmod_module_new_from_loo=
kup: input alias=3Diwlwifi, normalized=3Diwlwifi
> libkmod: DEBUG ../libkmod/libkmod-module.c:525 kmod_module_new_from_loo=
kup: lookup modules.dep iwlwifi
> libkmod: DEBUG ../libkmod/libkmod.c:542 kmod_search_moddep: use mmaped =
index 'modules.dep' modname=3Diwlwifi
> libkmod: DEBUG ../libkmod/libkmod.c:390 kmod_pool_get_module: get modul=
e name=3D'iwlwifi' found=3D(nil)
> libkmod: DEBUG ../libkmod/libkmod.c:398 kmod_pool_add_module: add 0x7f4=
0de8d8680 key=3D'iwlwifi'
> libkmod: DEBUG ../libkmod/libkmod.c:390 kmod_pool_get_module: get modul=
e name=3D'mac80211' found=3D(nil)
> libkmod: DEBUG ../libkmod/libkmod.c:390 kmod_pool_get_module: get modul=
e name=3D'mac80211' found=3D(nil)
> libkmod: DEBUG ../libkmod/libkmod.c:398 kmod_pool_add_module: add 0x7f4=
0de8dc3c0 key=3D'mac80211'
> libkmod: DEBUG ../libkmod/libkmod-module.c:178 kmod_module_parse_deplin=
e: add dep: /lib/modules/3.2.0-4-amd64/kernel/net/mac80211/mac80211.ko
> libkmod: DEBUG ../libkmod/libkmod.c:390 kmod_pool_get_module: get modul=
e name=3D'cfg80211' found=3D(nil)
> libkmod: DEBUG ../libkmod/libkmod.c:390 kmod_pool_get_module: get modul=
e name=3D'cfg80211' found=3D(nil)
> libkmod: DEBUG ../libkmod/libkmod.c:398 kmod_pool_add_module: add 0x7f4=
0de8dc530 key=3D'cfg80211'
> libkmod: DEBUG ../libkmod/libkmod-module.c:178 kmod_module_parse_deplin=
e: add dep: /lib/modules/3.2.0-4-amd64/kernel/net/wireless/cfg80211.ko
> libkmod: DEBUG ../libkmod/libkmod.c:390 kmod_pool_get_module: get modul=
e name=3D'rfkill' found=3D(nil)
> libkmod: DEBUG ../libkmod/libkmod.c:390 kmod_pool_get_module: get modul=
e name=3D'rfkill' found=3D(nil)
> libkmod: DEBUG ../libkmod/libkmod.c:398 kmod_pool_add_module: add 0x7f4=
0de8dc650 key=3D'rfkill'
> libkmod: DEBUG ../libkmod/libkmod-module.c:178 kmod_module_parse_deplin=
e: add dep: /lib/modules/3.2.0-4-amd64/kernel/net/rfkill/rfkill.ko
> libkmod: DEBUG ../libkmod/libkmod-module.c:184 kmod_module_parse_deplin=
e: 3 dependencies for iwlwifi
> libkmod: DEBUG ../libkmod/libkmod-module.c:546 kmod_module_new_from_loo=
kup: lookup iwlwifi=3D0, list=3D0x7f40de8d84e0
> libkmod: DEBUG ../libkmod/libkmod-module.c:1651 kmod_module_get_initsta=
te: could not open '/sys/module/iwlwifi/initstate': No such file or direc=
tory
> libkmod: DEBUG ../libkmod/libkmod-module.c:1661 kmod_module_get_initsta=
te: could not open '/sys/module/iwlwifi': No such file or directory
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_pcsp mod->name=3Drfkill mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_usb_audio mod->name=3Drfkill mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dbt87x mod->name=3Drfkill mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dcx88_alsa mod->name=3Drfkill mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_atiixp_modem mod->name=3Drfkill mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_intel8x0m mod->name=3Drfkill mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_via82xx_modem mod->name=3Drfkill mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dradeon mod->name=3Drfkill mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1220 kmod_module_probe_inser=
t_module: Ignoring module 'rfkill': already loaded
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_pcsp mod->name=3Dcfg80211 mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_usb_audio mod->name=3Dcfg80211 mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dbt87x mod->name=3Dcfg80211 mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dcx88_alsa mod->name=3Dcfg80211 mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_atiixp_modem mod->name=3Dcfg80211 mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_intel8x0m mod->name=3Dcfg80211 mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_via82xx_modem mod->name=3Dcfg80211 mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dradeon mod->name=3Dcfg80211 mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1651 kmod_module_get_initsta=
te: could not open '/sys/module/cfg80211/initstate': No such file or dire=
ctory
> libkmod: DEBUG ../libkmod/libkmod-module.c:1661 kmod_module_get_initsta=
te: could not open '/sys/module/cfg80211': No such file or directory
> libkmod: DEBUG ../libkmod/libkmod-module.c:709 kmod_module_get_path: na=
me=3D'cfg80211' path=3D'/lib/modules/3.2.0-4-amd64/kernel/net/wireless/cf=
g80211.ko'
> libkmod: DEBUG ../libkmod/libkmod-module.c:709 kmod_module_get_path: na=
me=3D'cfg80211' path=3D'/lib/modules/3.2.0-4-amd64/kernel/net/wireless/cf=
g80211.ko'
> insmod /lib/modules/3.2.0-4-amd64/kernel/net/wireless/cfg80211.ko=20
> libkmod: DEBUG ../libkmod/libkmod-module.c:709 kmod_module_get_path: na=
me=3D'cfg80211' path=3D'/lib/modules/3.2.0-4-amd64/kernel/net/wireless/cf=
g80211.ko'
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_pcsp mod->name=3Dmac80211 mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_usb_audio mod->name=3Dmac80211 mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dbt87x mod->name=3Dmac80211 mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dcx88_alsa mod->name=3Dmac80211 mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_atiixp_modem mod->name=3Dmac80211 mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_intel8x0m mod->name=3Dmac80211 mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_via82xx_modem mod->name=3Dmac80211 mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dradeon mod->name=3Dmac80211 mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1651 kmod_module_get_initsta=
te: could not open '/sys/module/mac80211/initstate': No such file or dire=
ctory
> libkmod: DEBUG ../libkmod/libkmod-module.c:1661 kmod_module_get_initsta=
te: could not open '/sys/module/mac80211': No such file or directory
> libkmod: DEBUG ../libkmod/libkmod-module.c:709 kmod_module_get_path: na=
me=3D'mac80211' path=3D'/lib/modules/3.2.0-4-amd64/kernel/net/mac80211/ma=
c80211.ko'
> libkmod: DEBUG ../libkmod/libkmod-module.c:709 kmod_module_get_path: na=
me=3D'mac80211' path=3D'/lib/modules/3.2.0-4-amd64/kernel/net/mac80211/ma=
c80211.ko'
> insmod /lib/modules/3.2.0-4-amd64/kernel/net/mac80211/mac80211.ko=20
> libkmod: DEBUG ../libkmod/libkmod-module.c:709 kmod_module_get_path: na=
me=3D'mac80211' path=3D'/lib/modules/3.2.0-4-amd64/kernel/net/mac80211/ma=
c80211.ko'
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_pcsp mod->name=3Diwlwifi mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_usb_audio mod->name=3Diwlwifi mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dbt87x mod->name=3Diwlwifi mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dcx88_alsa mod->name=3Diwlwifi mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_atiixp_modem mod->name=3Diwlwifi mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_intel8x0m mod->name=3Diwlwifi mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dsnd_via82xx_modem mod->name=3Diwlwifi mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options=
: modname=3Dradeon mod->name=3Diwlwifi mod->alias=3D(null)
> libkmod: DEBUG ../libkmod/libkmod-module.c:1651 kmod_module_get_initsta=
te: could not open '/sys/module/iwlwifi/initstate': No such file or direc=
tory
> libkmod: DEBUG ../libkmod/libkmod-module.c:1661 kmod_module_get_initsta=
te: could not open '/sys/module/iwlwifi': No such file or directory
> libkmod: DEBUG ../libkmod/libkmod-module.c:709 kmod_module_get_path: na=
me=3D'iwlwifi' path=3D'/lib/modules/3.2.0-4-amd64/kernel/drivers/net/wire=
less/iwlwifi/iwlwifi.ko'
> libkmod: DEBUG ../libkmod/libkmod-module.c:709 kmod_module_get_path: na=
me=3D'iwlwifi' path=3D'/lib/modules/3.2.0-4-amd64/kernel/drivers/net/wire=
less/iwlwifi/iwlwifi.ko'
> insmod /lib/modules/3.2.0-4-amd64/kernel/drivers/net/wireless/iwlwifi/i=
wlwifi.ko=20
> libkmod: DEBUG ../libkmod/libkmod-module.c:709 kmod_module_get_path: na=
me=3D'iwlwifi' path=3D'/lib/modules/3.2.0-4-amd64/kernel/drivers/net/wire=
less/iwlwifi/iwlwifi.ko'
> libkmod: DEBUG ../libkmod/libkmod-module.c:435 kmod_module_unref: kmod_=
module 0x7f40de8d8680 released
> libkmod: DEBUG ../libkmod/libkmod.c:406 kmod_pool_del_module: del 0x7f4=
0de8d8680 key=3D'iwlwifi'
> libkmod: DEBUG ../libkmod/libkmod-module.c:435 kmod_module_unref: kmod_=
module 0x7f40de8dc650 released
> libkmod: DEBUG ../libkmod/libkmod.c:406 kmod_pool_del_module: del 0x7f4=
0de8dc650 key=3D'rfkill'
> libkmod: DEBUG ../libkmod/libkmod-module.c:435 kmod_module_unref: kmod_=
module 0x7f40de8dc530 released
> libkmod: DEBUG ../libkmod/libkmod.c:406 kmod_pool_del_module: del 0x7f4=
0de8dc530 key=3D'cfg80211'
> libkmod: DEBUG ../libkmod/libkmod-module.c:435 kmod_module_unref: kmod_=
module 0x7f40de8dc3c0 released
> libkmod: DEBUG ../libkmod/libkmod.c:406 kmod_pool_del_module: del 0x7f4=
0de8dc3c0 key=3D'mac80211'
> libkmod: INFO ../libkmod/libkmod.c:319 kmod_unref: context 0x7f40de8d82=
50 released
>=20
> # dpkg -l |grep -i iwlwifi
> ii  firmware-iwlwifi                            0.40~bpo70+1           =
            all          Binary firmware for Intel Wireless cards
>=20
> https://packages.debian.org/wheezy-backports/firmware-iwlwifi shows tha=
t the 7260 card is part of the 0.40 iwlwifi driver package.
>=20
> And here is a listing of /dev/firmware showing that the ucode files are=
 actually installed=E2=80=A6
> # ls /lib/firmware/ |grep iwlwifi
> iwlwifi-1000-5.ucode
> iwlwifi-100-5.ucode
> iwlwifi-105-6.ucode
> iwlwifi-135-6.ucode
> iwlwifi-2000-6.ucode
> iwlwifi-2030-6.ucode
> iwlwifi-3160-7.ucode
> iwlwifi-3945-2.ucode
> iwlwifi-4965-2.ucode
> iwlwifi-5000-2.ucode
> iwlwifi-5000-5.ucode
> iwlwifi-5150-2.ucode
> iwlwifi-6000-4.ucode
> iwlwifi-6000g2a-5.ucode
> iwlwifi-6000g2a-6.ucode
> iwlwifi-6000g2b-6.ucode
> iwlwifi-6050-4.ucode
> iwlwifi-6050-5.ucode
> iwlwifi-7260-7.ucode
> iwlwifi-7260-8.ucode
>=20
> Does anyone have any ideas what might be going wrong and how I can fix =
it?
>=20
> Thanks in advance!!
> --
> Greg Ketell



--=20
Regards,
Oleksij


--dMMbma0St51hp8JS9riRjHwBlEii2qbp4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlMIVFEACgkQHwImuRkmbWmahgD9FEAfvYJ9wb25OpFEYgz5TbRi
oBi64lXkyphtLesTmqgA/iYFJ0Q5waw0jQY6UsvX+3P74+CMI2CFTfE/On5JTUjB
=YjkP
-----END PGP SIGNATURE-----

--dMMbma0St51hp8JS9riRjHwBlEii2qbp4--
