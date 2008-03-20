Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bugs.comnets.uni-bremen.de ([134.102.186.10]:55756 "EHLO
	bugs.comnets.uni-bremen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753130AbYCTIQf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 04:16:35 -0400
Date: Thu, 20 Mar 2008 09:16:34 +0100 (CET)
From: Markus Becker <mab@comnets.uni-bremen.de>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: Marvell 88w8335 [Libertas]
In-Reply-To: <200803191124.03743.hs4233@mail.mn-solutions.de>
Message-ID: <Pine.LNX.4.64.0803200904290.21835@bugs.comnets.uni-bremen.de> (sfid-20080320_081640_842159_5C5D5EDF)
References: <Pine.LNX.4.64.0803191037220.21835@bugs.comnets.uni-bremen.de>
 <200803191124.03743.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 19 Mar 2008, Holger Schurig wrote:

>> The module loads (does not bail out in the interrupt handler)
>> and creates the devices:
> ...
>> It is not yet fully working, however. The card does not seem
>> to react on the scanning/set_channel commands:
>
> This mailing list is more for the 838x chips, but we don't have a
> problem with occassional 833x e-mail traffic here.
>
>
> However, my advice is the following: As long as the driver's home
> is on some "obscure" tar files, it will always suffer from
> bitrot and not-so-much contribution by third partis. So aim to
> bring the driver into the linux kernel. Talk with John W.
> Linville on the linux-wireless mailing list about this.
> http://linuxwireless.org should give you pointers. For drivers,
> sometimes Linux accepts even not-so-good-code, when there is a
> chance that the beast get's better via re-factoring over time.

That would also be my preferred way, as this code has taken the route 
through a few people already (Luc Saillard, Andrea Merello and David 
Woodhouse).

> When if_cs.c went into the in-kernel-libertas driver, a few
> people that I never heard of found errors or sent bugfixes.
>
>
> Second advice: I think the BSD people (FreeBSD possible) have a
> m8k driver in their kernel tree. As I have heard, this beast
> actually works. So either look there for inspiration or try
> *BSD, pepper the code with debug printks and try to understand
> the differences between their code and the current linux code.

Yes, that is the malo driver, as far as I know. The mrv8k(ng) from 
http://david.woodhou.se/mrv.tar.gz is using the hardware constants and 
programming methods from that malo driver as stated in the mrv8.c.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
