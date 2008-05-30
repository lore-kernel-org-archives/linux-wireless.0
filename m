Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:45704 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbYE3PUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 11:20:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend vs. b43
Date: Fri, 30 May 2008 17:20:48 +0200
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1212150713.4117.2.camel@johannes.berg> <200805301642.05248.mb@bu3sch.de> <1212158782.4117.8.camel@johannes.berg>
In-Reply-To: <1212158782.4117.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805301720.49327.rjw@sisk.pl> (sfid-20080530_172038_361135_04C0088D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, 30 of May 2008, Johannes Berg wrote:
> On Fri, 2008-05-30 at 16:42 +0200, Michael Buesch wrote:
> > On Friday 30 May 2008 16:37:18 Johannes Berg wrote:
> > > Odd. Resume itself works just fine here, except when b43 is up. But then
> > > again, you might not notice that this is the problem because by default,
> > > nothing gets printed on the resume console and then it will indeed hang
> > > with a black screen.
> > 
> > How can I change the printing?
> 
> Hmm. It seems I might have been wrong here. Rafael, do we still have
> console suspend stuff?

Yes, we do.  Use "no_console_suspend" in the kernel command line to change
that, but note that it's not generally safe (eg. if you are using netconsole at
the same time).

Thanks,
Rafael
