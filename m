Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35807 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2BVVtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 16:49:12 -0500
Received: by iacb35 with SMTP id b35so577396iac.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Feb 2012 13:49:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA++WF2M99q70fj5KrH3HaFGL59ZSmjRHL5vgoDVoyp9zVuizXQ@mail.gmail.com>
References: <1328837032-26137-1-git-send-email-stas.yakovlev@gmail.com>
 <CAGRGNgWVsGt08gxoyaoG7sG7NgubF+qqjk=LaCruRJiUe1fuig@mail.gmail.com>
 <1328834790.5067.2.camel@dcbw.foobar.com> <CA++WF2M99q70fj5KrH3HaFGL59ZSmjRHL5vgoDVoyp9zVuizXQ@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 23 Feb 2012 08:48:52 +1100
Message-ID: <CAGRGNgUO41Jnzqgak9DNfvddWW4hJPb+U06AAE4nvxUM++Q8sg@mail.gmail.com> (sfid-20120222_224916_133284_707C51D3)
Subject: Re: [PATCH] ipw2x00: remove ipw2100_rates_11b[]
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislav,

On Thu, Feb 23, 2012 at 04:59, Stanislav Yakovlev
<stas.yakovlev@gmail.com> wrote:
> On 10 February 2012 03:46, Dan Williams <dcbw@redhat.com> wrote:
>> On Fri, 2012-02-10 at 11:26 +1100, Julian Calaby wrote:
>>> Hi Stanislav,
>>>
>>> On Fri, Feb 10, 2012 at 12:23, Stanislav Yakovlev
>>> <stas.yakovlev@gmail.com> wrote:
>>> > It's just a duplicate of ipw2100_bg_rates[].
>>>
>>> Looks sensible to me.
>>
>> Except that the 2100 is a B-only device; it doesn't do G at all.  So
>> wouldn't it make sense to get rid of ipw2100_rates_bg[] instead?
>
> It looks like we all agree that one of them should be removed. I did
> not see an easy way to remove ipw2100_rates_bg[]. Maybe it makes more
> sense to rename it to ipw2100_rates_b[]?

I'm not sure it makes much of a difference, but it can't hurt.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
