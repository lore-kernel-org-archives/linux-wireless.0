Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:40216 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462Ab0DSLxk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 07:53:40 -0400
Date: Mon, 19 Apr 2010 13:53:29 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: b43 'hardware blocked' but only keyboard/led touch button
Message-ID: <20100419115329.GA5306@frolo.macqel>
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
> 
> That's your bug, then.

I now boot with acpi.

Summary : I have a hp pavilion dv6-1300sb laptop with a b43 wifi device,
and a touchkey to disable or enable wifi with a red/blue led as feedback.

hp-wmi is loaded

when I touch the wifi key, I get the following messages (with 2.6.34-rc4) :

[  256.039395] atkbd.c: Unknown key pressed (translated set 2, code 0x94 on isa0060/serio0).
[  256.039408] atkbd.c: Use 'setkeycodes e014 <keycode>' to make it known.
[  256.062313] atkbd.c: Unknown key released (translated set 2, code 0x94 on isa0060/serio0).
[  256.062321] atkbd.c: Use 'setkeycodes e014 <keycode>' to make it known.

and the blue/red led doesn't change color, and wifi state does not change
either.

Any hint ?

Philippe
