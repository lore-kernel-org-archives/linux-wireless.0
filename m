Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7856 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab0C3TCf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 15:02:35 -0400
Subject: Re: Broadcom card totally not visible for system (lspci)
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?iso-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <4BB23953.9010104@lwfinger.net>
References: <b170af451003300956r7fbd7812jdb40d125aeaf1b32@mail.gmail.com>
	 <4BB2328D.9010503@lwfinger.net>
	 <b170af451003301031yd06f559j85fd30417af32113@mail.gmail.com>
	 <4BB23953.9010104@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 15:02:33 -0400
Message-Id: <1269975753.4938.8.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-03-30 at 12:48 -0500, Larry Finger wrote:
> On 03/30/2010 12:31 PM, Rafał Miłecki wrote:
> > 
> > Is this possible it's disabled in BIOS by default and needs execution
> > of some ACPI command or sth to make it work?
> > 
> > Yeah, trying to find some other reason than faulty WiFi... It's weird
> > it was working fine "before a moment" on Windows.
> 
> Winblows can fiddle with the "Wake-on-LAN" setting in the BIOS, but AFAIK, the
> BCM4306 does not have this capability. If the BIOS has that setting, it should
> be turned off.

Perhaps it's a crazy idea, but what if the Ethernet device and the WiFi
device are connected to the same SSB bus, an thus sharing the PCI ID?

Is there the full kernel log?  In particular, the lines containing "ssb"
would be interesting.

-- 
Regards,
Pavel Roskin
