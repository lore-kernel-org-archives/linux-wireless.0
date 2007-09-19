Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:48436
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071AbXISSjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 14:39:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: Please pull 'rt2x00' branch of wireless-2.6
Date: Wed, 19 Sep 2007 20:36:59 +0200
Cc: David Miller <davem@davemloft.net>, linville@tuxdriver.com,
	jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
References: <20070918213202.GJ4940@tuxdriver.com> <20070919.112137.48806758.davem@davemloft.net> <200709192048.00741.IvDoorn@gmail.com>
In-Reply-To: <200709192048.00741.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709192036.59443.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 19 September 2007 20:47:59 Ivo van Doorn wrote:
> On Wednesday 19 September 2007, David Miller wrote:
> > From: Ivo van Doorn <ivdoorn@gmail.com>
> > Date: Wed, 19 Sep 2007 20:31:19 +0200
> > 
> > > Because I am indeed not really happy with this early merge, but I'll do my
> > > best to resolve the last outstanding bugs as soon as possible.
> > 
> > Relax :-)
> 
> :)
> 
> > A merge upstream doesn't mean "bug free", it means "significantly
> > better than no driver at all" and that is undoubtedly the case
> > here.
> 
> Well I am happy rt2x00 is being considered good enough for upstream already,
> but I have the habbit of wanting things bug-free before pushing it further upstream.
> 
> Well most users are happy with current rt2x00 version anyway,
> so the remaining issues probably aren't that big anyway. (Except for the 2 panics,
> which should be resolved soon anyway) ;)

Well, you have nothing to lose, basically.
It's impossible for you to create a regression.
So everything is fine, even if it's buggy and doesn't
work at all. ;)

-- 
Greetings Michael.
