Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:50143 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbZGaSMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:12:13 -0400
Received: by ey-out-2122.google.com with SMTP id 9so610518eyd.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 11:12:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890907311107h56add3d9i9d7e825f55c8c40d@mail.gmail.com>
References: <20090731180556.GC7963@makis>
	 <43e72e890907311107h56add3d9i9d7e825f55c8c40d@mail.gmail.com>
Date: Fri, 31 Jul 2009 21:12:12 +0300
Message-ID: <40f31dec0907311112v7e463a1m4e5e39152e6fea01@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 2/4] ath5k: Linear PCDAC code fixes
From: Nick Kossifidis <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/31 Luis R. Rodriguez <mcgrof@gmail.com>:
> On Fri, Jul 31, 2009 at 11:05 AM, Nick
> Kossifidis<mick@madwifi-project.org> wrote:
>>  * Set correct xpd curve indices for high/low gain curves during
>>   rfbuffer setup on RF5112B with both calibration curves available.
>>
>>  * Don't return zero min power when we have the same pcdac value
>>   twice because it breaks interpolation. Instead return the right
>>   x barrier as we do when we have equal power levels for 2 different
>>   pcdac values.
>> ---
>>  drivers/net/wireless/ath/ath5k/phy.c |   24 +++++++++++++++++-------
>>  1 files changed, 17 insertions(+), 7 deletions(-)
>
> Missing SOB
>
>  Luis

Grrr, sorry ppl, resending...


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
