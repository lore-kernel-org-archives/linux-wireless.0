Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:41248 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYC3VtP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Mar 2008 17:49:15 -0400
From: Chr <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC][PATCH 0/2] p54: updates
Date: Sun, 30 Mar 2008 23:49:12 +0200
MIME-Version: 1.0
Cc: Michael Wu <flamingice@sourmilk.net>
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803302349.12587.chunkeey@web.de> (sfid-20080330_224926_735101_B3690416)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's been a long time... 

Since my machine has some weird problems with
any 2.6.25-rcX kernel and I don't have any 
prism54 softmac USB adaptors.... 
I hope someone else can help me with the review.

New features:
- p54pci specific:
  - activated tx and rx management rings
  - wrote a rx tasklet...
- general:
 - gave some _unknown_ parameters meaningful names
 - noise & signal strength in dBm rather than rssi values
 - enhanced promiscuous/monitor mode. 
   (Now it does capture more than just beacons!)


I'm planning to get the AP/AD-Hoc code ready for release too.
But.. All in its proper time.

Regards,
	Chr
