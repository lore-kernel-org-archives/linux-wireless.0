Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:64102 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759174Ab2C3Okv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 10:40:51 -0400
Received: by qadc11 with SMTP id c11so436515qad.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Mar 2012 07:40:51 -0700 (PDT)
Message-ID: <4F75C634.1010400@gmail.com> (sfid-20120330_164104_984770_CD30A373)
Date: Fri, 30 Mar 2012 10:41:56 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] compat: fix extreme build slowdowns
References: <1333105815.3908.11.camel@jlt3.sipsolutions.net>  <20341.39041.645223.592030@gargle.gargle.HOWL> <1333107022.3908.16.camel@jlt3.sipsolutions.net>
In-Reply-To: <1333107022.3908.16.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/12 07:30, Johannes Berg wrote:
> On Fri, 2012-03-30 at 16:56 +0530, Sujith Manoharan wrote:
>> Johannes Berg wrote:
>>> Somehow exporting too many variables completely confuses the kernel's
>>> Makefiles into trying to calculate the size of every file in a very slow
>>> shell script ... this is causing EXTREME build slowdowns for me.
>>>
>>> These two patches fix it.
>> Nice.
>>
>> Trying to build ath9k..
>>
>> Before:
>>
>> real    1m18.689s
>> user    3m1.382s
>> sys     0m6.833s
>>
>> After:
>>
>> real    0m42.091s
>> user    1m30.024s
>> sys     0m5.700s
Please put this in stable as well, seems like a good thing ;-)

Thanks,
Rick
> Yeah, I also see about 50% build time now with everything in cache, if
> the files it's sizing up aren't in cache then it can be much slower with
> the old version.
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

