Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:48919 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbZFCQc2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 12:32:28 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Jon Loeliger <jdl@bigfootnetworks.com>
Subject: Re: ar9170 vs otus advice?
Date: Wed, 3 Jun 2009 20:32:25 +0200
Cc: linux-wireless@vger.kernel.org
References: <1243894020.1559.22.camel@bigfoot-m4a75t> <200906030337.27448.chunkeey@web.de> <1244044799.1559.38.camel@bigfoot-m4a75t>
In-Reply-To: <1244044799.1559.38.camel@bigfoot-m4a75t>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200906032032.25344.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 03 June 2009 17:59:59 Jon Loeliger wrote:
> On Wed, 2009-06-03 at 03:37 +0200, Christian Lamparter wrote:
> > ar9170 - on the other hand -  is only capable of receiving 11n frames.
> > ( that said, enabling it makes the device unstable and therefore one can
> >   only _sniff_ 11n frames coming from other stations for now. )
> 
> Ewww....  So, does the ar9170 fully handle b/g as a station at least?
I'm not aware of any problems with/as a 802.11a/b/g station,
no one has reported any so far: so a/b/g works as _advertised_.
(at least for me and other developers)

> > > Advice on where I should start, what's working, what's not working,
> > > what needs help, etc?
> > a lot! first and foremost needed is the _final_ 802.11n specification,
> > which sadly will still take a while... (2010? I think at least...)
> > it's a really mess now...
> 
> Heh.  But I'm not going to be able to help that much... :-)
>
> >  As other devices/firmwares are usually designed
> > after a different revision of the drafts which makes it complicated.
> > This is no joke and the original otus incorporates "workarounds" for all
> > 11n vendors (including Atheros itself) to get it going.
> > ( else, the performance can be worse than 802.11b )
> 
> Is the in-tree Otus up-to-date with all of these workarounds?
I'm not really sure. the latest (and last) otus driver can be found here:
http://www.kernel.org/pub/linux/kernel/people/mcgrof/otus/

That said, I could get a decent HT20 (up to 70Mbits tx & 90 Mbit rx)
performance with the in-kernel driver... Does it work for you as well,
or are you asking, because it doesn't?

Regards,
	Chr
