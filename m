Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:51079 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab0C3UGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 16:06:50 -0400
Date: Tue, 30 Mar 2010 21:06:42 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Philippe De Muyter <phdm@macqel.be>
Cc: Dan Williams <dcbw@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: b43 'hardware blocked' but only keyboard/led touch button
Message-ID: <20100330200642.GA32654@srcf.ucam.org>
References: <20100329201236.GA9587@frolo.macqel> <4BB1335F.7030306@lwfinger.net> <20100330073401.GA13675@frolo.macqel> <1269967657.3019.16.camel@localhost.localdomain> <20100330171139.GA28367@srcf.ucam.org> <20100330192629.GA24060@frolo.macqel> <20100330193129.GA31847@srcf.ucam.org> <20100330200039.GA26538@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100330200039.GA26538@frolo.macqel>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 30, 2010 at 10:00:39PM +0200, Philippe De Muyter wrote:

> ACPI: I/O resource 0000:00:1f.3 [0x8000-0x801f] conflicts with ACPI region SMBI [0x8000-0x800f] (copied by hand)

That's harmless. It just indicates that ACPI is telling us not to drive 
your SMBus controller directly.

> > 
> > That's your bug, then.
> 
> Any hint on what I can do to diagnose more what the problem(s) is/are ?

Best plan would be to post a complete description of the problem to 
linux-acpi@vger.kernel.org.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
