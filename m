Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP01.calltower.com ([69.4.184.248]:31563 "EHLO
	L01SLCSMTP01.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752581AbZFCQAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 12:00:19 -0400
Subject: Re: ar9170 vs otus advice?
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200906030337.27448.chunkeey@web.de>
References: <1243894020.1559.22.camel@bigfoot-m4a75t>
	 <200906030337.27448.chunkeey@web.de>
Content-Type: text/plain
Date: Wed, 03 Jun 2009 10:59:59 -0500
Message-Id: <1244044799.1559.38.camel@bigfoot-m4a75t>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-06-03 at 03:37 +0200, Christian Lamparter wrote:

> > 
> > So, I'm trying to understand the current state of the ar9170 and otus
> > drivers so that I may know where to direction some effort.  I'd like to
> > get an WN111v2 running with 11n support, and am willing to start with
> > either the ar9170 or otus drivers as needed.  But I've not been following
> > along in too much detail so far.
> 
> well, otus is a dead end. However it does fully support all 11n features the
> device has to offer. But you'll need a special and very old wpa_supplicant.
> (see otus' driver page on wireless.kernel.org where to get it.)

OK, got it, thanks.

> ar9170 - on the other hand -  is only capable of receiving 11n frames.
> ( that said, enabling it makes the device unstable and therefore one can
>   only _sniff_ 11n frames coming from other stations for now. )

Ewww....  So, does the ar9170 fully handle b/g as a station at least?

> > Advice on where I should start, what's working, what's not working,
> > what needs help, etc?
> a lot! first and foremost needed is the _final_ 802.11n specification,
> which sadly will still take a while... (2010? I think at least...)
> it's a really mess now...

Heh.  But I'm not going to be able to help that much... :-)

>  As other devices/firmwares are usually designed
> after a different revision of the drafts which makes it complicated.
> This is no joke and the original otus incorporates "workarounds" for all
> 11n vendors (including Atheros itself) to get it going.
> ( else, the performance can be worse than 802.11b )

Is the in-tree Otus up-to-date with all of these workarounds?


> > And should I start with one of the linville Git trees? Or wireless-everything?
> 
> linville's wireless-testing is where we put the most recent code.

Excellent.

> Regards,
> 	Chr

Thanks,
jdl


