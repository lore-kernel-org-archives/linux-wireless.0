Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:22268 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983AbXBEO4F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 09:56:05 -0500
Received: by an-out-0708.google.com with SMTP id b33so1037352ana
        for <linux-wireless@vger.kernel.org>; Mon, 05 Feb 2007 06:56:05 -0800 (PST)
Message-ID: <9e4733910702050656v5739c03ta3fa6563ed1236a8@mail.gmail.com>
Date: Mon, 5 Feb 2007 09:56:04 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: SoftMAC vs FullMAC
Cc: "Michael Buesch" <mb@bu3sch.de>, "Pavel Roskin" <proski@gnu.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890702050028s33645f3exf8b1f97a783925e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <9e4733910702040922n63736d27h7ab027dc90ae8989@mail.gmail.com>
	 <200702042007.29357.mb@bu3sch.de>
	 <9e4733910702041144n277facd1g6af9c4659afc6d39@mail.gmail.com>
	 <200702042111.17005.mb@bu3sch.de>
	 <9e4733910702041246s750fc8ach73e29a8c17727145@mail.gmail.com>
	 <43e72e890702050028s33645f3exf8b1f97a783925e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/5/07, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> just because it makes our lives easier. MS may have done what they did
> to help with their development efforts but it doesn't mean it was
> necessarily good for technology. We want to work with vendors to
> support their devices regardless of how stupid their design is --
> ultimately our job is to support hardware for our users and not take
> on political quests to dictate the path of technology.

I wouldn't say MS did this for political reasons, I believe it was
more for technical reasons based on the simple observation that the
host CPU was 5-10 times the speed of the coprocessors. The dumb
Ethernet card design was also lower cost which expanded the market.
3COM actually came up with NDIS and then MS adopted it.

For the 'smart' card vendors they then had to implement the stack all
the way up to the NETBIOS layer without help from MS. They weren't
shut out, but they got no support either. The burden of software
implementation, plus the fact that the cards were 10x more expensive
and slower, led to their ultimate failure.

Looking back on this NDIS really helped the LAN industry by
commoditizing the hardware. The market hugely expanded since the
hardware was dirt cheap and very easy to use.

-- 
Jon Smirl
jonsmirl@gmail.com
