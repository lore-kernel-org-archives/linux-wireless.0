Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:34128 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727AbaH0Gzm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 02:55:42 -0400
Message-ID: <53FD7BFA.1040304@maya.org> (sfid-20140827_085547_320145_DF2CD524)
Date: Wed, 27 Aug 2014 08:34:34 +0200
From: Andreas Hartmann <andihartmann@freenet.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	poma <pomidorabelisima@gmail.com>
CC: ling.sun@mediatek.com, xun.guo@mediatek.com,
	recruit.sg@mediatek.com, GSS_MTK_WCN_ACS@mediatek.com,
	Meng Zhang <meng.zhang@mediatek.com>,
	zoran.zvonar@mediatek.com, maria.crockett@mediatek.com,
	jc.yang@mediatek.com, mingto.yu@mediatek.com,
	chichen.lee@mediatek.com, paul-ph.huang@mediatek.com,
	christian.kermarrec@mediatek.com, arun.gupta@mediatek.com,
	daisy.wu@mediatek.com, gaosen.zhang@mediatek.com,
	eric.yeh@mediatek.com, hr.mbj@mediatek.com,
	andrea.tsai@mediatek.com, Paul Lin <paul_lin@ralinktech.com>,
	shu-rung.ye@mediatek.com, msz_dh3_all_manager@mediatek.com,
	mk.tsai@mediatek.com, muyi.chen@mediatek.com,
	weihua.ma@mediatek.com, shawmin.lei@mediatek.com,
	yongzhen.chen@mediatek.com, tony.pereira@mediatek.com,
	sophia.liang@mediatek.com, dyas.wu@mediatek.com,
	careers.usa@mediatek.com, kelvin.chou@mediatek.com,
	fan.chen@mediatek.com, mz.lee@mediatek.com,
	xianlai.zhong@mediatek.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com, priya.s@mediatek.com,
	sharon.lo@mediatek.com, jl.lin@mediatek.com,
	suyan.zhang@mediatek.com, in.oh@mediatek.com,
	kuanghua.wen@mediatek.com, noida.jobs@mediatek.com
Subject: Re: [rt2x00-users] MediaTek Inc. MT7601U Wireless Adapter
References: <53FCC55B.90705@gmail.com> <20140826182849.GE30445@tuxdriver.com>
In-Reply-To: <20140826182849.GE30445@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Tue, Aug 26, 2014 at 07:35:23PM +0200, poma wrote:
>>
>> Say, hi fi to everybody!
>>
>> Driver "mt7601Usta"(DPO_MT7601U_LinuxSTA_3.0.0.4_20130913.tar.bz2) for the MediaTek MT7601U based wireless adapters - on a sale worldwide, is broken and obsolete.
>> MediaTek folks, 
>> please consider the release of an upgraded version of the driver for the current stable Linux kernel, and the upcoming.
>> Thanks.
> 
> It would be much better if the MediaTek folks would just send us
> patches for the drivers already in the kernel...


No. Sorry. The existing rt2800-driver is mostly broken and unusable
compared with the original Ralink drivers. Especially the usb drivers
are extremely bad. There are huge differences between the ralink usb
drivers (rt5572sta e.g.) and the rt2800usb driver. The ralink drivers
are working fine with a few additional patches even with kernel 3.15 and
with 64bit(!!).

@MediaTek
Please provide own drivers as before as the existing rt2800 drivers
should be reworked completely - but from my point of view they are dead
since long time now.
It is much better to have one basically good working driver (which must
be patched manually to work with newer kernels because newer kernels
often aren't downwardly compatible - if they would be, there wouldn't be
any problem even with older drivers. But this is a huge problem of Linux
at all).


Regards and thanks to Ralink / Mediatek for providing own drivers!
Andreas Hartmann
