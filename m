Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:54455
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992987AbXBQSO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 13:14:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: More breakage in wireless-dev.git
Date: Sat, 17 Feb 2007 19:14:06 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <1171690868.31103.17.camel@dv> <200702171856.08068.mb@bu3sch.de> <20070217131045.tsmois8g0og8okc4@webmail.spamcop.net>
In-Reply-To: <20070217131045.tsmois8g0og8okc4@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702171914.06802.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 17 February 2007 19:10, Pavel Roskin wrote:
> Quoting Michael Buesch <mb@bu3sch.de>:
> 
> > On Saturday 17 February 2007 18:51, Pavel Roskin wrote:
> > > > The slab error on the end of your dmesg is interresting, though.
> > >
> > > I'll have a closer look.
> >
> > I think that's fixed now, too.
> 
> Awesome!  I'm waiting for your public repository to update so I can test your
> fixes.

I always update that when committing stuff, directly.
So when you see mail from me "I committed foo", it means it's
available in the public repository.

-- 
Greetings Michael.
