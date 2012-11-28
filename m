Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.legal.de ([46.38.240.131]:52536 "EHLO mail.legal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389Ab2K1Ok0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 09:40:26 -0500
Message-ID: <50B62254.9070700@schwarze-allianz.de> (sfid-20121128_154030_976419_FCB7DFFB)
Date: Wed, 28 Nov 2012 15:40:20 +0100
From: Jens Kapitza <j.kapitza@schwarze-allianz.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi hibernate / suspend issue
References: <50B61C71.6060007@schwarze-allianz.de> (sfid-20121128_152227_935873_AFE02FFF) <1354113010.9345.27.camel@jlt4.sipsolutions.net>
In-Reply-To: <1354113010.9345.27.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 28.11.2012 15:30, schrieb Johannes Berg:
> No, the firmware is stopped anyway during suspend, the card is powered
> off. Can you please post message output? We should read the rfkill state
> during resume, maybe there's a race. Also, what kernel version?
>
> johannes
root@jens-S4216:/home/jens# uname -a
Linux jens-S4216 3.6.7 #2 SMP Sat Nov 24 19:30:21 CET 2012 x86_64 x86_64 
x86_64 GNU/Linux

if testet linux-image-3.7.0-rc7-wl+_3.7.0-rc7-wl+ with same issue

where can i found the output? never startet the debug mode in linux-kernel ?

root@jens-S4216:/home/jens/git# rfkill --version
rfkill 0.4-1ubuntu3 (Ubuntu)

root@jens-S4216:/home/jens/git# modinfo iwlwifi
filename: /lib/modules/3.6.7/kernel/drivers/net/wireless/iwlwifi/iwlwifi.ko
license:        GPL
author:         Copyright(c) 2003-2012 Intel Corporation 
<ilw@linux.intel.com>
version:        in-tree:
description:    Intel(R) Wireless WiFi driver for Linux
firmware:       iwlwifi-100-5.ucode
firmware:       iwlwifi-1000-5.ucode
firmware:       iwlwifi-135-6.ucode
firmware:       iwlwifi-105-6.ucode
firmware:       iwlwifi-2030-6.ucode
firmware:       iwlwifi-2000-6.ucode
firmware:       iwlwifi-5150-2.ucode
firmware:       iwlwifi-5000-5.ucode
firmware:       iwlwifi-6000g2b-6.ucode
firmware:       iwlwifi-6000g2a-5.ucode
firmware:       iwlwifi-6050-5.ucode
firmware:       iwlwifi-6000-4.ucode
srcversion:     E11EC5DDFB79C1C159DCD22


jens
