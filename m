Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:41260 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874AbYKOXSW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2008 18:18:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Nico -telmich- Schottelius" <nico-linux-iwlwifi5100@schottelius.org>
Subject: Re: 2.6.28-rc4: iwlagn / 5100 state
Date: Sun, 16 Nov 2008 00:22:43 +0100
Cc: LKML <linux-kernel@vger.kernel.org>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
References: <20081114150508.GC4877@denkbrett.schottelius.org>
In-Reply-To: <20081114150508.GC4877@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811160022.43906.rjw@sisk.pl> (sfid-20081116_001826_235053_F7E262AB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Cc to linux-wireless@vger.kernel.org)

On Friday, 14 of November 2008, Nico -telmich- Schottelius wrote:
> Hello!
> 
> Using that kernel I see the following features / bugs:
> 
>    - loading the firmware "freezes" the system for a few seconds
>    - setting the link up of wlan0 "freezes" the system for a few seconds
>    - connecting to 802.11b/g works (802.11a is untested)
>    - roaming does *NOT* work -> just looses the AP, does not connect
>      to other AP with same essid
>    - connecting to a ap sometimes does not work, though essid is set
>       -> sometimes it helps to specify "ap <addr>"
>       -> sometimes setting down and up the link helps
>       -> with earlier kernels one sometimes needed to rmmod and insmod
>          the module again, so there is some progress :-)
> 
> So far it is somehow usable, though the connection problems and missing
> roaming is a bit painful.
