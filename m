Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57040 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab3D1PEJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Apr 2013 11:04:09 -0400
Received: from mailout-de.gmx.net ([10.1.76.4]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MJ0dz-1UTzF01hQP-002UiO for
 <linux-wireless@vger.kernel.org>; Sun, 28 Apr 2013 17:04:07 +0200
Message-ID: <517D3A5F.6020205@rempel-privat.de> (sfid-20130428_170424_238131_41A5ED93)
Date: Sun, 28 Apr 2013 17:03:59 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: Re: [ath9k-devel] [PATCH RFC] ath9k: collect statistics about Rx-Dup
 and Rx-STBC packets
References: <1367076326-21616-1-git-send-email-linux@rempel-privat.de> <517D1B45.9020302@openwrt.org> <517D2E77.8000104@rempel-privat.de>
In-Reply-To: <517D2E77.8000104@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 28.04.2013 16:13, schrieb Oleksij Rempel:
> Am 28.04.2013 14:51, schrieb Felix Fietkau:
>> On 2013-04-27 5:25 PM, Oleksij Rempel wrote:
>>> Collect statistics about recived duplicate and STBC packets.
>>> This information should help see if STBC is actually working.
>>>
>>> Tested on ar9285;
>>>
>>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>> I thought about this patch some more, and I'm wondering what's the point
>> in doing this? These statistics are going to be completely useless for
>> most people and they'll waste some memory/cpu cycles, especially on
>> small-cache devices. I think it's much more useful to simply pass the
>> information to mac80211 via rx flags and get them added to the radiotap
>> header.
>
> Sure.
>

I see Wojciech Dubowik sanded some patches, for at least one year, to 
make exactly what Felix suggested. Are there any reason why this patches 
was not accepted?
Wojciech if you alive and have some time, can you update them?
-- 
Regards,
Oleksij
