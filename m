Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:55778 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab1EaNDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 09:03:07 -0400
Message-ID: <20110531160301.41337kl145hokrwo@www.81.fi> (sfid-20110531_150311_692967_7DA36E10)
Date: Tue, 31 May 2011 16:03:02 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>
Subject: Re: [RFC PATCH 03/27] zd1211rw: include mac80211.h from zd_chip.h
References: <802107.19454.qm@web161618.mail.bf1.yahoo.com>
In-Reply-To: <802107.19454.qm@web161618.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Walter Goldens <goldenstranger@yahoo.com>:

>
>> Date: Sunday, May 29, 2011, 11:04 PM
>> zd_chip.h contains one function with
>> a pointer to ieee80211_hw but doesn't
>> include mac80211.h. As a temporary solution include
>> mac80211.h to avoid
>> a warning.
>
> I'm still getting a warning with this patch. I think this happened  
> when Jussi fixed some stuff awhile back.
>
> In function ‘zd_mac_alloc_hw’:
> drivers/net/wireless/zd1211rw/zd_mac.c:1340:7: warning: statement  
> with no effect

Hm.. I'm not getting this with wireless-testing.

>
> Walter
>
>


