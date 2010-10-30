Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54657 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab0J3OvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Oct 2010 10:51:23 -0400
Date: Sat, 30 Oct 2010 10:49:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Walter Goldens <goldenstranger@yahoo.com>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Realtek rtl8188 support?
Message-ID: <20101030144947.GA2058@tuxdriver.com>
References: <201010292202.25486.s.L-H@gmx.de>
 <694082.86488.qm@web56803.mail.re3.yahoo.com>
 <AANLkTimnuHM3E3G=d+R4-b=1NDkdEQ9jkbQsqB9ASiEC@mail.gmail.com>
 <4CCB99CB.9000400@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4CCB99CB.9000400@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 29, 2010 at 11:06:35PM -0500, Larry Finger wrote:
> On 10/29/2010 04:27 PM, Gábor Stefanik wrote:
> > 
> > AFAIK we only add staging drivers that will eventually move out of
> > staging. r8712 has no chance of ever leaving staging; a completely new
> > driver needs to be written (because it isn't mac80211-based).
> 
> That is correct, but it should not be too long until there is a mac80211 driver
> for that chip. I just got GPLd sources from Realtek for a mac80211-based driver
> for the RTL8192CE PCIe device. It will need only a small amount of work to make
> it ready for mainline. The critical part is that it uses the same chip as is
> used in the RTL8712 USB device.

Sounds like good news...

> For those that are interested in the RTL8187SE, I'm told that they have a
> working mac80211 driver for it, but that it is not yet stable.

More good news!  Even if that device is aging, this indicates that
Realtek is getting serious about working with the community, even on
older devices.

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
