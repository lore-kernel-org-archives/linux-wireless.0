Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:46467 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbYG3Jrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 05:47:43 -0400
Received: by wf-out-1314.google.com with SMTP id 27so424089wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2008 02:47:43 -0700 (PDT)
Message-ID: <40f31dec0807300247y4e92e5bfn6e55bffec5556356@mail.gmail.com> (sfid-20080730_114747_740125_63D5AE51)
Date: Wed, 30 Jul 2008 12:47:43 +0300
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

I'll repost this patch with the changes included in patch 12, then it
won't break build ;-)



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
