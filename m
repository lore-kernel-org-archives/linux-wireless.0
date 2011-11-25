Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59066 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab1KYEnh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 23:43:37 -0500
Received: by wwp14 with SMTP id 14so3010917wwp.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Nov 2011 20:43:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322159944.5366.42.camel@jlt3.sipsolutions.net>
References: <1322016630-27332-1-git-send-email-mar.kolya@gmail.com>
	<1322158678.5366.27.camel@jlt3.sipsolutions.net>
	<CALGY4fv6NTRDPUEa-7h+DqaHZwdKnNG4fEmzyHrYZukz3B1gqA@mail.gmail.com>
	<1322159944.5366.42.camel@jlt3.sipsolutions.net>
Date: Thu, 24 Nov 2011 23:43:36 -0500
Message-ID: <CALGY4ftKV_u0avbXytHOxRWWiDiDBGhAKTCE+_QqJnebt8Rj=Q@mail.gmail.com> (sfid-20111125_054342_041295_4193C0D4)
Subject: Re: [PATCH v2 0/3] mac80211: timeout tx agg sessions in way similar
 to rx agg sessions
From: Nikolay Martynov <mar.kolya@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

2011/11/24 Johannes Berg <johannes@sipsolutions.net>:
> On Thu, 2011-11-24 at 13:33 -0500, Nikolay Martynov wrote:
>
>> > Looks OK to me. Did you run it through sparse too? :-)
>> >
>>   Please forgive my lack of experience, but could you please point me
>> to some docs where I can read about sparse and how to use it? I'd
>> really appreciate this.
>
> Sure, FWIW, I'm just asking because I received lots of patches recently
> that later got sparse warnings. I guess you normally run something like
>
> make M=net/mac80211
>
> To run sparse, you add C=1 (just run sparse if cc runs) or C=2 (run
> sparse on all files). Obviously you need to install sparse first, your
> distribution probably has packages.
>

  I wasn't able to find any sparse warnings introduced by my changes,
everything looks fine.

-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
