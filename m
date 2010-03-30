Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:23173 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754857Ab0C3UAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 16:00:45 -0400
Date: Tue, 30 Mar 2010 22:00:39 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: b43 'hardware blocked' but only keyboard/led touch button
Message-ID: <20100330200039.GA26538@frolo.macqel>
References: <20100329201236.GA9587@frolo.macqel> <4BB1335F.7030306@lwfinger.net> <20100330073401.GA13675@frolo.macqel> <1269967657.3019.16.camel@localhost.localdomain> <20100330171139.GA28367@srcf.ucam.org> <20100330192629.GA24060@frolo.macqel> <20100330193129.GA31847@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100330193129.GA31847@srcf.ucam.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 30, 2010 at 08:31:29PM +0100, Matthew Garrett wrote:
> On Tue, Mar 30, 2010 at 09:26:29PM +0200, Philippe De Muyter wrote:
> 
> > I must also add that I currently cannot boot without acpi=off

I shoudl have written ; linux does not boot without acpi=off, and the messages
I get with ignore_loglevel debug do never stop at the same place.  Do you know
how to reliably find where the apci problem is.

I noticed this message :

ACPI: I/O resource 0000:00:1f.3 [0x8000-0x801f] conflicts with ACPI region SMBI [0x8000-0x800f] (copied by hand)

but linux seems to continue to boot past that.

> 
> That's your bug, then.

Any hint on what I can do to diagnose more what the problem(s) is/are ?

Philippe

PS: without acpi=off, the led is blue, but I have no linux :(

-- 
Philippe De Muyter  phdm at macqel dot be  Tel +32 27029044
Macq Electronique SA  rue de l'Aeronef 2  B-1140 Bruxelles  Fax +32 27029077
