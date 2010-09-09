Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1839 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab0IIPKV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 11:10:21 -0400
Message-ID: <4C88F8CE.5090708@broadcom.com>
Date: Thu, 9 Sep 2010 08:10:06 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
MIME-Version: 1.0
To: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
cc: "Henry Ptasinski" <henryp@broadcom.com>
Subject: [ANN] Full-source Broadcom wireless driver for 11n chips
References: <20100908150322.17dac9c3@nehalam>
 <20100908225132.GA12490@kroah.com>
In-Reply-To: <20100908225132.GA12490@kroah.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Broadcom would like to announce the initial release of a fully-open
Linux driver for it's latest generation of 11n chipsets.  The driver,
while still a work in progress, is released as full source and uses the
native mac80211 stack.   It supports multiple current chips (BCM4313,
BCM43224, BCM43225) as well as providing a framework for supporting
additional chips in the future, including mac80211-aware embedded chips.
   The README and TODO files included with the sources provide more
details about the current feature set, known issues, and plans for
improving the driver.

The driver is currently available in staging-next git tree, available at:

	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git

in the drivers/staging/brcm80211 directory.

---
Henry Ptasinski
henryp@broadcom.com

