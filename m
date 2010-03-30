Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:38360 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab0C3RLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 13:11:45 -0400
Date: Tue, 30 Mar 2010 18:11:39 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Philippe De Muyter <phdm@macqel.be>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: b43 'hardware blocked' but only keyboard/led touch button
Message-ID: <20100330171139.GA28367@srcf.ucam.org>
References: <20100329201236.GA9587@frolo.macqel> <4BB1335F.7030306@lwfinger.net> <20100330073401.GA13675@frolo.macqel> <1269967657.3019.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1269967657.3019.16.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 30, 2010 at 09:47:37AM -0700, Dan Williams wrote:

> It could be that hp-wmi doesn't have support for these models yet, or
> that the dv6-1300sb is simply completely different.  But for example, on
> my Elitebook 2530p, there's a softswitch that pokes BIOS, and when BIOS
> is softkilled, the onboard wifi becomes hardkilled.  To unkill, I need
> to unblock BIOS, which then either unblocks wifi, or turns the wifi
> hardkill into a softkill.  Convoluted.

Yeah. I'd be interested in seeing the output of acpidump on this 
machine, but right now it sounds like b43 is behaving correctly - the 
fact that the light is out implies that the bios is killing it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
