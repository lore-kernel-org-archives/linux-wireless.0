Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:50111 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbYAFVjz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 16:39:55 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: b43 will need a firmware upgrade soon
Date: Sun, 6 Jan 2008 22:38:14 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200801061802.38297.mb@bu3sch.de> <20080106203435.GA18833@tuxdriver.com>
In-Reply-To: <20080106203435.GA18833@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801062238.14472.mb@bu3sch.de> (sfid-20080106_213958_500644_591CEFFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 06 January 2008 21:34:35 John W. Linville wrote:
> On Sun, Jan 06, 2008 at 06:02:38PM +0100, Michael Buesch wrote:
> 
> > This is needed in order to add support for new devices (N-PHY).
> > Broadcom changed the ABI of the firmware, so we are forced to also
> > change the ABI of the driver.
> 
> Do we have reasonable confidence that the newer firmware will run
> on all the devices currently supported by b43?  Or are we looking at
> another b43legacy type of situation?

We need to check this.
Maybe we can support both firmware images in the driver. Not sure yet.

-- 
Greetings Michael.
