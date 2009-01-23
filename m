Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55391 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771AbZAWTvY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 14:51:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Subject: Re: integration of opensource firmware with b43 kernel driver
Date: Fri, 23 Jan 2009 20:50:27 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <FF33C500-6653-4A69-B34D-FBE47B2136D3@ing.unibs.it> <200901232033.28470.mb@bu3sch.de> <FE3E070D-F92B-4A76-80E5-019D4735FBED@ing.unibs.it>
In-Reply-To: <FE3E070D-F92B-4A76-80E5-019D4735FBED@ing.unibs.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901232050.27952.mb@bu3sch.de> (sfid-20090123_205132_728772_84AE66F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 January 2009 20:46:45 Francesco Gringoli wrote:
> -- Is using the Broadcom names for the firmware the best course of
> -- action? What if the opensource firmware files were named something
> -- like "os-ucode5.fw", etc. and b43 were coded to check for those files
> -- first? It would then fall back to the standard firmware if the
> -- opensource version is not found.

I answered to this question with this patch:
http://bu3sch.de/patches/wireless-testing/20081227-1821/patches/008-b43-probe-open-fw.patch

I am currently testing an updated version of the patch and I'll push it upstream tomorrow.

-- 
Greetings, Michael.
