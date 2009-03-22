Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:54662 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbZCVNRG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 09:17:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Kernel panic with zd1211rw and today's compat-wireless
Date: Sun, 22 Mar 2009 14:15:46 +0100
Cc: "Alexander E. Patrakov" <patrakov@gmail.com>,
	linux-wireless@vger.kernel.org
References: <20090322174515.22f11d92@home.aephome.ru> <1237726612.19647.2.camel@johannes.local>
In-Reply-To: <1237726612.19647.2.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903221415.46630.mb@bu3sch.de> (sfid-20090322_141711_534980_663CA9E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 22 March 2009 13:56:52 Johannes Berg wrote:
> On Sun, 2009-03-22 at 17:45 +0500, Alexander E. Patrakov wrote:
> 
> > There are several different panic messages,
> > the common thing is "Fatal exception in interrupt". Without uvesafb,
> > they also include "zd_op_tx+0x98/0x1cc [zd1211rw]" as the last line,
> 
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff;h=3b23889bb2366c1b10f69bcca16cf53426b5e309

This looks like something else. I can't see the skb_under_panic message.

http://picasaweb.google.com/patrakov/KernelPanic?authkey=Gv1sRgCKn5ne2jqbLYpAE&feat=directlink#5315991155862429026

-- 
Greetings, Michael.
