Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:32944 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbYG1Ooj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 10:44:39 -0400
Received: by wf-out-1314.google.com with SMTP id 27so5774694wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 07:44:38 -0700 (PDT)
Message-ID: <40f31dec0807280744r22d9d279n3c6713f16ba29ac1@mail.gmail.com> (sfid-20080728_164441_832943_598E3E62)
Date: Mon, 28 Jul 2008 17:44:38 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [ath5k-devel] [PATCH 12/12] ath5k: Fix a compilation error after reg list update
Cc: "Jiri Slaby" <jirislaby@gmail.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@gmail.com
In-Reply-To: <1217250601.2441.20.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080720035221.GL7440@makis> <4885F055.8000304@gmail.com>
	 <40f31dec0807280604m19a8c511nf2568bb7aa357b90@mail.gmail.com>
	 <1217250601.2441.20.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/7/28 Pavel Roskin <proski@gnu.org>:
> On Mon, 2008-07-28 at 16:04 +0300, Nick Kossifidis wrote:
>
>> > Please amend this to the patch 1 to not break bisectability.
>>
>> I see your point but this series is meant to be applied as a whole, i
>> didn't notice this bug until i tested the code with debugging enabled
>> (which is off by default), that's why it's "last minute fix". Is it
>> really that much needed to repost the first patch ? I mean the patch
>> series works and doesn't introduce any problems...
>
> The reason is that git-bisect divides the number of commits in half and
> checks out the middle commit.  That commit make be a broken one.
> Hitting one bug while hunting another is not nice.
>
> Besides, nobody wants to apply a known bad patch.
>
> It would be great if you repost fixed patches.  If you are not using
> stgit, please try it.  I would make it easy to return to older patches
> and change them.  "stg edit -d" even allows editing the patch.
>
> --
> Regards,
> Pavel Roskin
>

O.K. then i'll repost the first patch asap (i'm still in Ottawa :P)...

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
