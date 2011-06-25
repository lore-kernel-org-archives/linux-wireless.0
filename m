Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46567 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab1FYObL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2011 10:31:11 -0400
Message-ID: <4E05F12B.4020302@openwrt.org> (sfid-20110625_163123_122941_AED3FB88)
Date: Sat, 25 Jun 2011 16:31:07 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Misha Shnurapet <shnurapet@fedoraproject.org>
CC: Community support for Fedora users
	<users@lists.fedoraproject.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: AR9280 won't initialize
References: <152381309010939@web35.yandex.ru>
In-Reply-To: <152381309010939@web35.yandex.ru>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-06-25 4:08 PM, Misha Shnurapet wrote:
> Hi.
>
> I have a little problem. I replaced the old BCM4312 card on my Dell mini 1011 (10v) with:
> 03:00.0 Network controller: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)
>
> But it won't work.
>
> First it crashed Linux:
> http://pastebin.com/YmEGcPK8
>
> Then I installed a system update:
> http://funkyimg.com/u2/879/849/2.png
> http://pastebin.com/hWG6u7VJ
>
> And now it is:
>
> [   30.589243] ath9k 0000:03:00.0: PCI INT A ->  GSI 17 (level, low) ->  IRQ 17
> [   30.589269] ath9k 0000:03:00.0: setting latency timer to 64
> [   30.594884] ath: address test failed addr: 0x00008000 - wr:0xaaaaaaaa != rd:0xaaaa2aaa
> [   30.594898] ath: Unable to initialize hardware; initialization status: -19
> [   30.594913] ath9k 0000:03:00.0: Failed to initialize device
> [   30.594991] ath9k 0000:03:00.0: PCI INT A disabled
>
> lsusb:
> http://pastebin.com/JHYZiDhr
>
> Installing the latest stable compat-wireless from source didn't help (bleeding edge won't build).
>
> I would appreciate if you help me.
Looks like a hardware issue to me. Try removing the card and plugging it 
back in.

- Felix
