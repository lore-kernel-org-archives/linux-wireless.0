Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:33328 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668AbXBNWyz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Feb 2007 17:54:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] bcm43xx: Fix for 4311 and 02/07/07 specification changes
Date: Wed, 14 Feb 2007 23:51:00 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
References: <45d241c0.gWJcHxUYgWmBTwx8%Larry.Finger@lwfinger.net>
In-Reply-To: <45d241c0.gWJcHxUYgWmBTwx8%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702142351.01381.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, 13 February 2007 23:54, Larry Finger wrote:
> The specifications for the bcm43xx driver have been modified. This patch
> incorporates these changes in the code, which results in the BCM4311 and
> BCM4312 working. The name of one of the PHY parameters, previously known
> as "version", has been changed to "analog", short for  "analog core version" .
>
> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>

I have tested this patch and it works on my box, FWIW.

Greetings,
Rafael

-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
