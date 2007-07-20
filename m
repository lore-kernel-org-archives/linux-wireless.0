Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:34551 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759483AbXGTDNA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 23:13:00 -0400
Date: Fri, 20 Jul 2007 05:09:32 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: bcm4301: A mac80211 driver using V3 firmware
Message-ID: <20070720050932.5052468c@morte>
In-Reply-To: <46A01209.4030200@lwfinger.net>
References: <46963C0F.3080104@lwfinger.net>
	<20070719215801.GB12449@tuxdriver.com>
	<20070720012714.0dc0298a@morte>
	<46A01209.4030200@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 19 Jul 2007 20:38:17 -0500
Larry Finger <larry.finger@lwfinger.net> wrote:

> 4. Once bcm43xx-mac80211 gets merged to mainline, then Michael's driver
> should become bcm43xx and my driver gets its PCI IDs stripped to the
> 802.11b-only devices and once again becomes bcm4301. This name change for
> Michael's driver would cause some disruption for current users as their
> firmware would have the wrong name/version. That might be too much of a
> problem.

No, as long as we preserve the current firmware naming scheme. Some
distributions are already shipping both the softmac and the mac80211 based
drivers, with fwcutter installation scripts meant for dealing with this.
Some clear printk's in both drivers should do the rest.


-- 
Ciao
Stefano
