Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37360 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbZAWSI7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 13:08:59 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: integration of opensource firmware with b43 kernel driver
Date: Fri, 23 Jan 2009 19:08:05 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <FF33C500-6653-4A69-B34D-FBE47B2136D3@ing.unibs.it> <497A05DC.4040101@lwfinger.net>
In-Reply-To: <497A05DC.4040101@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901231908.05835.mb@bu3sch.de> (sfid-20090123_190903_883583_4DDCE5F0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 January 2009 19:01:00 Larry Finger wrote:
> The driver can certainly be coded to look for the open-source firmware
> names before trying to load vendor firmware. That way there will not
> be any confusion.

I already posted that, but in case you missed it:
http://bu3sch.de/patches/wireless-testing/20081227-1821/patches/008-b43-probe-open-fw.patch

-- 
Greetings, Michael.
