Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:45350 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbYE3OG7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 10:06:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: suspend vs. b43
Date: Fri, 30 May 2008 16:07:23 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
References: <1212150713.4117.2.camel@johannes.berg>
In-Reply-To: <1212150713.4117.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805301607.24378.rjw@sisk.pl> (sfid-20080530_160701_135844_4FD9F3FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, 30 of May 2008, Johannes Berg wrote:
> Hi,

Hi,

> Since a while ago I've had trouble resuming when b43 was connected to an
> AP while suspended.
> 
> I did a test today where this was the only difference, but I failed to
> see whether ssb or b43 were causing the problem.
> 
> Does anyone have a machine with b43 in it that can suspend and supports
> the RTC-trace feature so we can narrow it down? Even reproducing might
> help to make sure it's not just something weird with my powerbook.

No, it's not.  It just doesn't work, AFAICS.

My box is only able to suspend (without hanging) if NetworkManager is switched
off or b43 is unloaded before an attempt to.

Unfortunately, I didn't have the time to fight with that.

Thanks,
Rafael
