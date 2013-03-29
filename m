Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:35016 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab3C2ArG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 20:47:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130328225300.GA20285@kroah.com>
References: <CAB=NE6WLuz7-QD3v4BwZkLLNUed=X7jgvZtZX8cDEh3HiD51oQ@mail.gmail.com>
 <20130328225300.GA20285@kroah.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 28 Mar 2013 17:46:44 -0700
Message-ID: <CAB=NE6UF97ETqXXyNFCRRhv=d=AgA=nq3d830uG+pvykAmB2xA@mail.gmail.com> (sfid-20130329_014724_913263_5B4DB052)
Subject: Re: Possibility for an external staging tree - bring up quality code
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Adrian Chadd <adrian@freebsd.org>, Jouni Malinen <j@w1.fi>,
	Kalle Valo <kvalo@adurom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Kathy Giori <Kathy.Giori@qca.qualcomm.com>,
	Yanbo Li <dreamfly281@gmail.com>,
	Mathieu Olivari <mathieu@qca.qualcomm.com>,
	"k.eugene.e" <k.eugene.e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 28, 2013 at 3:53 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Mar 28, 2013 at 01:13:23PM -0700, Luis R. Rodriguez wrote:
>
> <huge snip>
>
>> This has me thinking if it makes sense to have an external driver tree
>> for staging drivers but lead by engineers who already know the rules
>> of upstream, they just want to get things done faster.
>
> That's called a "fork" or "tree" or whatever you want to call it, and
> all of us have them, and end up merging stuff to mainline through them
> eventually.
>
> There is no need to "codify" something that we all have been doing for
> years.  If someone thinks they can "work faster" in their own tree,
> great for them, have them do it.  I don't see what I need to agree or
> disagree with here to keep anyone from doing such a thing.
>
> Or am I just totally missing something here?

OK, yes I think we can work better if we had an external trees for
each driver to cherry pick them as they get sanitized, prior to
upstream for *some* drivers. Very well. I'll simply let vendors /
developers get their 802.11 driver as part of compat-drivers so long
as they maintain their poo.

  Luis
