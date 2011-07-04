Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:56947 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab1GDOhY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 10:37:24 -0400
Message-ID: <20110704173721.41945e5und30zo08@www.81.fi> (sfid-20110704_163729_857670_CDA04883)
Date: Mon, 04 Jul 2011 17:37:21 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [PATCH 3/6] zd1211rw: only update HW beacon if new beacon
 differs from currect
References: <1309610075.77698.YahooMailClassic@web161606.mail.bf1.yahoo.com>
In-Reply-To: <1309610075.77698.YahooMailClassic@web161606.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Walter Goldens <goldenstranger@yahoo.com>:

>
>
> --- On Mon, 6/20/11, Jussi Kivilinna <jussi.kivilinna@mbnet.fi> wrote:
>
>> This appears to make device work in AP-mode
>> (dtim_period=1) somewhat more stable.
>>
>> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>
> Jussi,
>
> I ran a hostapd AP with a zd1211b device, and while the stability is  
> relatively OK, throughput appears to be below-par. The most I was  
> able to get was about 3.5 megabits. Do you experience any throughput  
> issues yourself and what is the average speed you see when you  
> transfer files?

I have throughput issue when doing transfers in both directions at  
same time. I get 17-19 Mbps when transfering in one direction only.  
However if I start download and upload at sametime, zd1211rw AP can  
only do tx at about 3.5 Mbps when other end is not zd1211rw too. With  
zd1211rw at both ends tx average 8-10 Mbps. Same problem exists when  
using zd1211rw device on b43 AP.

-Jussi

>
> Walter
>





