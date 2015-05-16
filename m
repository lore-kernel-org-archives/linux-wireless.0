Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53948 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbbEPFYk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 01:24:40 -0400
Message-ID: <5556D48B.3090708@rempel-privat.de> (sfid-20150516_072445_296512_6710786B)
Date: Sat, 16 May 2015 07:24:27 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>, ath9k-devel@qca.qualcomm.com,
	kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: add phy.c
References: <1431693340-8861-1-git-send-email-linux@rempel-privat.de> <55564A50.2050004@openwrt.org>
In-Reply-To: <55564A50.2050004@openwrt.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 15.05.2015 um 21:34 schrieb Felix Fietkau:
> On 2015-05-15 14:35, Oleksij Rempel wrote:
>> ... and move dup code from ar5008_phy.c and ar9002_phy.c to phy.c
>>
>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
> We already have base functionality for AR5008-AR9002 provided in some
> ar5008_phy.c, and ar5008_hw_attach_phy_ops is called for those chipsets
> as well. Please keep the de-duplicated code there instead of adding a
> new phy.c, because AR9003+ uses a completely different codepath.
> 
> - Felix
> 

ok, thanks.
Currently i celled this function phy_hw_spur_mitigate(), is it ok or
there is some better name for this code?


-- 
Regards,
Oleksij
