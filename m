Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.versatel.nl ([62.58.50.88]:33454 "EHLO smtp1.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248AbYDJQn5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 12:43:57 -0400
Subject: Re: hostapd hangs on rt2500pci, leaving the nic in an unstable
	state
From: Bas Hulsken <bhulsken@hotmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <200804091933.03615.IvDoorn@gmail.com>
References: <1207412527.6965.21.camel@Bas> <1207590445.3028.2.camel@Bas>
	 <200804091932.09459.IvDoorn@gmail.com>
	 <200804091933.03615.IvDoorn@gmail.com>
Content-Type: text/plain
Date: Thu, 10 Apr 2008 18:39:56 +0200
Message-Id: <1207845596.2907.2.camel@Bas> (sfid-20080410_174401_315593_00D090F4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, 2008-04-09 at 19:33 +0200, Ivo van Doorn wrote:

> > Does the patch by Daniel Wagner:
> > 	rt61pci: rt61pci_beacon_update do not free skb twice
> > which was send to the linux-wireless mailing list today help?
> 
> wait never mind, that was a stupid comment since you are using rt2500pci... :S
> I'll see if the patch also is applicable for rt2500pci and post that patch if that is
> the case. :)

I assume the patch as it applies to rt2500pci is this one: "rt2x00: Only
free skb when beacon_update fails"

I've tried it, and it does not solve the problem, still exactly the same
hang as before.

Bas


