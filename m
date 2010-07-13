Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-202-190.clients.your-server.de ([88.198.202.190]:40732
	"EHLO kleinhenz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab0GMNGa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 09:06:30 -0400
Date: Tue, 13 Jul 2010 15:06:14 +0200
From: Simon Richter <sjr@debian.org>
To: Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Ben Hutchings <ben@decadent.org.uk>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org, 588196@bugs.debian.org
Subject: Re: Bug#588196: b43: does not join multicast groups
Message-ID: <20100713130614.GB25565@richter>
References: <20100706021937.11147.78230.reportbug@debian.hogyros.de>
 <1278887148.6139.91.camel@localhost>
 <4C3A4C6E.6060801@lwfinger.net>
 <20100713051430.GA2625@honey.hogyros.de>
 <4C3BFB87.5030907@lwfinger.net>
 <20100713073751.GB3089@richter>
 <4C3C6350.50304@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4C3C6350.50304@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Jul 13, 2010 at 03:00:00PM +0200, Michael Büsch wrote:

> But I wanna say again that this all is expected behavior. The PIO
> fallback workaround randomly drops packets when switching modes.
> So it is expected that certain handshaking packages may be lost.

So if the handshake to join a MC group is lost for whatever reason, it
is lost forever, or is that just in the "shit happened, reset
everything" code path?

> >I was also having some suspend related issues, I'm going to give it a
> >few days now to see whether they also disappear now.

> Please open a new bug for this. Thanks.

If they keep appearing; this may also be related to lost packets.

   Simon
