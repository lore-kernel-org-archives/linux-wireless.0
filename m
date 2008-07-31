Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:44422 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbYGaSvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 14:51:50 -0400
Received: by yw-out-2324.google.com with SMTP id 9so420022ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2008 11:51:49 -0700 (PDT)
Message-ID: <40f31dec0807311151m13bc2c5ah65b477d2d0ae3fd1@mail.gmail.com> (sfid-20080731_205153_475277_3190D10B)
Date: Thu, 31 Jul 2008 21:51:48 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH 1/12] ath5k: Update register list
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mcgrof@gmail.com
In-Reply-To: <20080729204054.GA10188@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080720033041.GA7440@makis>
	 <20080729204054.GA10188@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/7/29 John W. Linville <linville@tuxdriver.com>:
> On Sun, Jul 20, 2008 at 06:30:41AM +0300, Nick Kossifidis wrote:
>>  * Update list of registers
>>  * Use updated register macros inside hw.c and initvals.c
>>
>>  Changes-licensed-under: ISC
>>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> Nick,
>
> Some of the changes in this patch break the build unless the rest
> of the series is applied, and those patches can't be applied before
> applying this one.  This breaks git-bisect.  Could I trouble you
> to include the pieces of this patch that break the build into those
> later patches that fix the build?  Or perhaps you can simply split
> this into a patch that adds new definitions and one that deletes
> older definitions?  The latter could then be applied at the end of
> the series.
>
> Thanks,
>
> John

Hello John ;-)

Now that i resent the 1st patch that was broken can you please commit
the series ? We really need to add RF2425 support in kernel, it'll
also help me work easier on ath5k (i won't have to work on top of
those patches).

All other patches should be O.K.



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
