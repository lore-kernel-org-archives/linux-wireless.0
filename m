Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760146AbXHND0m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 23:26:42 -0400
Subject: Re: 802.11S
From: Dan Williams <dcbw@redhat.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <9e4733910708130900r1fceb7fahe44e146bee04584d@mail.gmail.com>
References: <9e4733910708130900r1fceb7fahe44e146bee04584d@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 23:22:52 -0400
Message-Id: <1187061772.14098.3.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-08-13 at 12:00 -0400, Jon Smirl wrote:
> What's going on with 802.11S? I know about it's use in the OLPC but it
> is running inside the Marvell device. Is anyone working on a 802.11S
> stack for the host?

The CozyBit guys, who did the in-firmware implementation for OLPC, have
said they are looking at making a mac80211-based 802.11s implementation
that will also be interoperable with the Marvell 8388 firmware
implementation that OLPC is using.  There have been some mails about
that recently:

Dan

------------------
Data: Fri, 6 Jul 2007 08:40:58 -0700 (11:40 EDT)
Sugject: Re: libertas (private) ioctls vs. nl80211
From: Javier Cardona

We (cozybit Inc.) are working on an open implementation of 802.11s for
Linux, based on mac80211.  We implemented an early draft
implementation of 802.11s for the Marvell wireless interface used on
the One Laptop Per Child.  That implementation was done entirely in
firmware to take advantage of the unique capabilities of Marvell's
wireless device:  the system-on-chip wireless module enables the
laptop to act as a low-power, fully functional mesh point even when
the main CPU is off.

Our next goal is to do a reference implementation of the latest
802.11s draft on Linux.  The hope is that it will help to achieve
early interoperability and convergence of the standard.  We are
seeking sponsors for the project.  So far Nortel has expressed strong
interest.
-----------------


