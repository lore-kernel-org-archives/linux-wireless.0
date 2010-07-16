Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:50639 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964971Ab0GPK5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jul 2010 06:57:53 -0400
Date: Fri, 16 Jul 2010 06:57:45 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: Felix Fietkau <nbd@openwrt.org>
cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: Re: what's the status of ATHEROS_AR71XX config variable?
In-Reply-To: <4C403859.70201@openwrt.org>
Message-ID: <alpine.DEB.2.00.1007160656240.18878@lynx>
References: <alpine.DEB.2.00.1007160440530.13924@lynx> <4C403859.70201@openwrt.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 16 Jul 2010, Felix Fietkau wrote:

> On 2010-07-16 10:43 AM, Robert P. J. Day wrote:
> >
> >   from drivers/net/wireless/ath/ath9k/Makefile:
> >
> > ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o
> >
> > but there is no such config variable.  so i'm thinking *something*
> > should be removed.

> The platform port for AR71xx hasn't been submitted upstream yet. But
> the code in ahb.c is actively being used in OpenWrt.
>
> I don't know what the status on submitting the code to linux-mips
> is, but I've Cc'd Gabor, he should know ;)

  ok.  i wasn't passing judgment one way or the other, just making an
observation that the mainstream kernel doesn't define that config
variable.  you can take it from here.

rday

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Top-notch, inexpensive online Linux/OSS/kernel courses
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
