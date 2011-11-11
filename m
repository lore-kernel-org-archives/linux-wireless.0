Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57215 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab1KKMsT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 07:48:19 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1ROqWo-0000Vf-9T
	for linux-wireless@vger.kernel.org; Fri, 11 Nov 2011 13:48:18 +0100
Subject: Re: off- & multi-channel operation
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1320844134.3845.61.camel@jlt3.sipsolutions.net> (sfid-20111109_140902_212963_943EDBDE)
References: <1320844134.3845.61.camel@jlt3.sipsolutions.net>
	 (sfid-20111109_140902_212963_943EDBDE)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Nov 2011 13:48:15 +0100
Message-ID: <1321015695.3977.167.camel@jlt3.sipsolutions.net> (sfid-20111111_134823_117238_B1FEED41)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-09 at 14:08 +0100, Johannes Berg wrote:

> How do we want to handle these things? I'm sure I want the drivers to
> handle multi-channel operation fairly transparently, with multiple
> (hardware) queues (in the driver), so mac80211 doesn't have to
> start/stop the queues continuously and can just transmit on that
> interface, the frame might only go out a bit later.

Hmm, off-channel TDLS is also an interesting case ...

Maybe we need to have a channel for each station? And get timing info
from the device somehow for all the negotiation? Obviously stations
connected to an AP would all have the same channel etc...

johannes

