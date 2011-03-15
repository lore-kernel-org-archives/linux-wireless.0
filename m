Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail81.extendcp.co.uk ([79.170.40.81]:53406 "EHLO
	mail81.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757666Ab1CONTA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 09:19:00 -0400
Date: Tue, 15 Mar 2011 13:19:07 +0000
From: Tony Houghton <h@realh.co.uk>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Could ath9k and rt2800pci bugs be related?
Message-ID: <20110315131907.6f06a221@toddler>
In-Reply-To: <AANLkTimSZrGCzBaB9K=WVO7faGNM-+qeKEE2qzjkPnSD@mail.gmail.com>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<20110314164812.4c0cfc29@toddler>
	<AANLkTimSZrGCzBaB9K=WVO7faGNM-+qeKEE2qzjkPnSD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 15 Mar 2011 13:17:40 +0530
Mohammed Shafi <shafi.wireless@gmail.com> wrote:

> On Mon, Mar 14, 2011 at 10:18 PM, Tony Houghton <h@realh.co.uk> wrote:
> >
> > I've just bought an Acer Aspire Revo 3700 and this had very similar
> > symptoms with a different adapter. Luckily another customer had
> > posted about it on the vendor's website and his fix works for me.
> > The fix is to blacklist the rt2800pci module and the rt2860sta
> > driver seems to work quite happily without it.
> 
> can you please check by disabling the supicious rt modules and see
> whether this problems happens.

Yes, I did blacklist rt2800pci and the system works correctly without
the module loaded. Even the wireless connection still works.

> for quick check please try with the latest compat wireless.

How do I do that?

I would also be willing to add extra debugging messages to ath9k to help
track down the AR9285 problem. I'm a C programmer, but not a kernel
hacker so I think I would need some advice about which functions to
examine.
