Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:38267 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274Ab1EBU43 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 16:56:29 -0400
Received: from [195.4.92.13] (helo=3.mx.freenet.de)
	by mout2.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.72 #5)
	id 1QH0AL-00067U-Vk
	for linux-wireless@vger.kernel.org; Mon, 02 May 2011 22:56:25 +0200
Received: from p54a1973e.dip0.t-ipconnect.de ([84.161.151.62]:39822 helo=mail.maya.org)
	by 3.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #3)
	id 1QH0AL-0000Zd-Nz
	for linux-wireless@vger.kernel.org; Mon, 02 May 2011 22:56:25 +0200
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
	by mail.maya.org (8.14.4/8.13.8) with ESMTP id p42KuLYX003150
	for <linux-wireless@vger.kernel.org>; Mon, 2 May 2011 22:56:22 +0200
Message-ID: <4DBF1AF5.7000409@01019freenet.de> (sfid-20110502_225632_635634_5E602DE5)
Date: Mon, 02 May 2011 22:58:29 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Please fix compat-wireless for 2.6.34.9
References: <9223.32487.qm@web161608.mail.bf1.yahoo.com>
In-Reply-To: <9223.32487.qm@web161608.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Walter Goldens wrote:
> 
> 
> --- On Mon, 5/2/11, Andreas Hartmann <andihartmann@01019freenet.de> wrote:
> 
>> modprobe rt2800pci
>> WARNING: Error inserting rfkill
>> (/lib/modules/2.6.34.9-4-desktop/kernel/net/rfkill/rfkill.ko):
>> Invalid
>> module format
>> WARNING: Error inserting cfg80211
>> (/lib/modules/2.6.34.9-4-desktop/updates/net/wireless/cfg80211.ko):
>> Invalid module format
>> WARNING: Error inserting mac80211
>> (/lib/modules/2.6.34.9-4-desktop/updates/net/mac80211/mac80211.ko):
>> Invalid module format
>> WARNING: Error inserting rt2x00lib
>> (/lib/modules/2.6.34.9-4-desktop/updates/drivers/net/wireless/rt2x00/rt2x00lib.ko):
>> Invalid module format
>> WARNING: Error inserting rt2x00pci
>> (/lib/modules/2.6.34.9-4-desktop/updates/drivers/net/wireless/rt2x00/rt2x00pci.ko):
>> Invalid module format
>> WARNING: Error inserting crc_ccitt
>> (/lib/modules/2.6.34.9-4-desktop/kernel/lib/crc-ccitt.ko):
>> Invalid
>> module format
>> WARNING: Error inserting rt2800lib
>> (/lib/modules/2.6.34.9-4-desktop/updates/drivers/net/wireless/rt2x00/rt2800lib.ko):
>> Invalid module format
>> FATAL: Error inserting rt2800pci
>> (/lib/modules/2.6.34.9-4-desktop/updates/drivers/net/wireless/rt2x00/rt2800pci.ko):
> 
> Hi,
> 
> Did you unload (all) the wireless modules before modprobe-ing rt2800pci?

yes - compat-wireless-2.6.39-rc1-3 works fine. It worked with kernel
2.6.34.8, too. But not with 2.6.34.9 (2.6.34.9-4-desktop from OpenSuSE).



Andreas
