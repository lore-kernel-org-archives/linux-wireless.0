Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:56274 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab0DSPGf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 11:06:35 -0400
Date: Mon, 19 Apr 2010 16:06:28 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Philippe De Muyter <phdm@macqel.be>
Cc: Dan Williams <dcbw@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: b43 'hardware blocked' but only keyboard/led touch button
Message-ID: <20100419150627.GA10680@srcf.ucam.org>
References: <20100329201236.GA9587@frolo.macqel> <4BB1335F.7030306@lwfinger.net> <20100330073401.GA13675@frolo.macqel> <1269967657.3019.16.camel@localhost.localdomain> <20100330171139.GA28367@srcf.ucam.org> <20100330192629.GA24060@frolo.macqel> <20100330193129.GA31847@srcf.ucam.org> <20100419115329.GA5306@frolo.macqel> <20100419145107.GB8017@srcf.ucam.org> <20100419150050.GA28290@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100419150050.GA28290@frolo.macqel>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 19, 2010 at 05:00:50PM +0200, Philippe De Muyter wrote:
> On Mon, Apr 19, 2010 at 03:51:07PM +0100, Matthew Garrett wrote:
> > On Mon, Apr 19, 2010 at 01:53:29PM +0200, Philippe De Muyter wrote:
> > 
> > > and the blue/red led doesn't change color, and wifi state does not change
> > > either.
> > 
> > What's the output of the rfkill command now?
> 
> Sorry, I cannot answer before friday (not my laptop).

No problem. The best command to run will be

rfkill list

and then just attach the output.

Thanks,
-- 
Matthew Garrett | mjg59@srcf.ucam.org
