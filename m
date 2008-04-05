Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:55589 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbYDEMZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2008 08:25:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] b43: Fix PHY TX control words in SHM
Date: Sat, 5 Apr 2008 14:24:57 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <200804042143.07849.mb@bu3sch.de>
In-Reply-To: <200804042143.07849.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804051424.57434.mb@bu3sch.de> (sfid-20080405_132537_194323_2092B62C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 04 April 2008 21:43:07 Michael Buesch wrote:
> This fixes the initialization of the PHY TX control words in
> shared memory. These control words are used for management frames
> like beacons.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> John, this is for 2.6.26
> 

Please hold off on this one. It has a tiny bug. I'll send a fixed version later.
However you can apply [PATCH] b43: Beaconing fixes
But I'll also send a followup patch to this that will fix more things, soon.

-- 
Greetings Michael.
