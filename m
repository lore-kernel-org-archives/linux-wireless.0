Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:64203 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756760AbXKUPBD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 10:01:03 -0500
Message-ID: <47444825.4070505@lwfinger.net> (sfid-20071121_150110_312722_AD3AD70B)
Date: Wed, 21 Nov 2007 09:00:53 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: schedule bcm43xx removal for 2.6.26 -- Re: [PATCH v3] remove
 bcm43xx
References: <20071119202121.6ad3fa70@morte> <200711192357.44407.rjw@sisk.pl> <200711201509.55763.mb@bu3sch.de> <200711210026.49732.rjw@sisk.pl> <20071121135927.GC8792@tuxdriver.com>
In-Reply-To: <20071121135927.GC8792@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> 
> It is probably true that we haven't communicated this very well
> outside the wireless team.  We probably should have added bcm43xx to
> the feature removal schedule before the 2.6.24 merge window closed.
> 
> How about if we mark bcm43xx as "Obsolete" in MAINTAINERS and add
> an entry to Documentation/feature-removal-schedule.txt with a "When"
> of 2.6.26?  I think that should give everyone sufficient notice...?

This sounds good to me. Of course, we all understand that once 2.6.25 is released, _EVERY_
complaint/bug report for bcm43xx and SoftMAC will get the response "switch to 2.6.25"!

Larry
