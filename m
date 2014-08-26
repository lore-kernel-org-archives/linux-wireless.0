Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:46524 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaHZRfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2014 13:35:30 -0400
Received: by mail-we0-f181.google.com with SMTP id k48so15125150wev.12
        for <linux-wireless@vger.kernel.org>; Tue, 26 Aug 2014 10:35:29 -0700 (PDT)
Message-ID: <53FCC55B.90705@gmail.com> (sfid-20140826_193534_347375_3448E2EC)
Date: Tue, 26 Aug 2014 19:35:23 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: GSS_MTK_WCN_ACS@mediatek.com
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Meng Zhang <meng.zhang@mediatek.com>,
	Paul Lin <paul_lin@ralinktech.com>, sharon.lo@mediatek.com,
	andrea.tsai@mediatek.com, mz.lee@mediatek.com,
	jc.yang@mediatek.com, chichen.lee@mediatek.com,
	zoran.zvonar@mediatek.com, shu-rung.ye@mediatek.com,
	shawmin.lei@mediatek.com, mingto.yu@mediatek.com,
	careers.usa@mediatek.com, maria.crockett@mediatek.com,
	xun.guo@mediatek.com, daisy.wu@mediatek.com, ling.sun@mediatek.com,
	noida.jobs@mediatek.com, hr.mbj@mediatek.com,
	yongzhen.chen@mediatek.com, eric.yeh@mediatek.com,
	kelvin.chou@mediatek.com, xianlai.zhong@mediatek.com,
	paul-ph.huang@mediatek.com, mk.tsai@mediatek.com,
	gaosen.zhang@mediatek.com, sophia.liang@mediatek.com,
	weihua.ma@mediatek.com, jl.lin@mediatek.com, fan.chen@mediatek.com,
	priya.s@mediatek.com, dyas.wu@mediatek.com,
	kuanghua.wen@mediatek.com, in.oh@mediatek.com,
	recruit.sg@mediatek.com, msz_dh3_all_manager@mediatek.com,
	arun.gupta@mediatek.com, muyi.chen@mediatek.com,
	suyan.zhang@mediatek.com, tony.pereira@mediatek.com,
	christian.kermarrec@mediatek.com
Subject: MediaTek Inc. MT7601U Wireless Adapter
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Say, hi fi to everybody!

Driver "mt7601Usta"(DPO_MT7601U_LinuxSTA_3.0.0.4_20130913.tar.bz2) for the MediaTek MT7601U based wireless adapters - on a sale worldwide, is broken and obsolete.
MediaTek folks, 
please consider the release of an upgraded version of the driver for the current stable Linux kernel, and the upcoming.
Thanks.

These are the results of tests starting with: 
$ modinfo mt7601Usta
filename:       /lib/modules/2.6.32-431.23.3.el6.x86_64/updates/mt7601Usta.ko
version:        3.0.0.3
description:    RT2870 Wireless Lan Linux Driver
author:         Paul Lin <paul_lin@ralinktech.com>
license:        GPL
srcversion:     E3EE381863883B309D682BB
alias:          usb:v148Fp7601d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v148Fp6370d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v148Fp7650d*dc*dsc*dp*ic*isc*ip*
depends:        
vermagic:       2.6.32-431.23.3.el6.x86_64 SMP mod_unload modversions 
parm:           mac:rt28xx: wireless mac addr (charp)

and the ending with: 
$ modinfo mt7601Usta 
filename:       /lib/modules/3.16.0-1.fc21.x86_64/updates/mt7601Usta.ko
version:        3.0.0.3
description:    RT2870 Wireless Lan Linux Driver
author:         Paul Lin <paul_lin@ralinktech.com>
license:        GPL
srcversion:     DB56E18D38EF6269211CFA0
alias:          usb:v148Fp7601d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v148Fp6370d*dc*dsc*dp*ic*isc*ip*in*
alias:          usb:v148Fp7650d*dc*dsc*dp*ic*isc*ip*in*
depends:        
vermagic:       3.16.0-1.fc21.x86_64 SMP mod_unload 
parm:           mac:rt28xx: wireless mac addr (charp)


WORKING:
2.6.32-431.23.3.el6.x86_64
2.6.43.8-2.fc15.x86_64

WORKING - WITH REDUCED THROUGHPUT AND DISCONNECTIONS
3.0.0-1.fc16.x86_64
3.1.0-1.fc16.x86_64
3.2.0-2.fc17.x86_64
3.3.0-1.fc17.x86_64
3.3.8-1.fc16.x86_64

BROKEN - OPERATING SYSTEM CRASHES:
3.4.0-1.fc18.x86_64
3.4.2-4.fc17.x86_64

BROKEN - CANNOT COMPILE - WITH UNOFFICIAL PATCHES OPERATING SYSTEM CRASHES:
3.10.0-123.6.3.el7.x86_64
3.12.10-300.fc20.x86_64
3.15.10-200.fc20.x86_64
3.16.0-1.fc21.x86_64


poma


Ref.
http://forum.ubuntu.org.cn/viewtopic.php?f=116&t=456228
http://www.mediatek.com/en/downloads/
http://www.mediatek.com/en/downloads/mt7610u-usb/
DPO_MT7601U_LinuxSTA_3.0.0.4_20130913.tar.bz2

