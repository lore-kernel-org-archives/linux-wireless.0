Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:61143 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab3IRNSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 09:18:17 -0400
Received: by mail-bk0-f51.google.com with SMTP id mx10so2881999bkb.10
        for <linux-wireless@vger.kernel.org>; Wed, 18 Sep 2013 06:18:16 -0700 (PDT)
Message-ID: <5239A815.40909@gmail.com> (sfid-20130918_151831_084214_F1BC41E1)
Date: Wed, 18 Sep 2013 15:18:13 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: peter@stuge.se, linux-wireless <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: RT3573 wpa_supplicant: "nl80211: Delete station $my_ap" after
 "SME: Send 20/40 BSS Coexistence to $my_ap"
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Stuge wrote:

> I'm testing the WNDA4100 with torvalds/linux.git and as of a day or
> two ago and wpa_supplicant-2.0.
> 
> I haven't measured throughput. Latency is really bad for interactive
> connections, but at least the packets are flowing on all bands. Yay!
> 
> Ping to the access point is around 3 ms with the odd 20+ ms when the
> kernel goes off to do something else.

Support for RT3573 was added recently, you should use wireless-next:
http://git.kernel.org/cgit/linux/kernel/git/linville/wireless-next.git

You can also try latest fw(v0.33):
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/attachments/20130111/f8ebe4d3/attachment.bin

md5sum:
======
ac4f6d8b679945208a978e397c016aa7 rt2870.bin (8192 bytes)

# mv /lib/firmware/rt2870.bin /lib/firmware/rt2870.bin.orig
# mv attachment.bin /lib/firmware/rt2870.bin
