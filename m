Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4527 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbYAFVGp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 16:06:45 -0500
Date: Sun, 6 Jan 2008 15:34:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: b43 will need a firmware upgrade soon
Message-ID: <20080106203435.GA18833@tuxdriver.com> (sfid-20080106_210700_194924_63BD8B79)
References: <200801061802.38297.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200801061802.38297.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 06, 2008 at 06:02:38PM +0100, Michael Buesch wrote:

> This is needed in order to add support for new devices (N-PHY).
> Broadcom changed the ABI of the firmware, so we are forced to also
> change the ABI of the driver.

Do we have reasonable confidence that the newer firmware will run
on all the devices currently supported by b43?  Or are we looking at
another b43legacy type of situation?

John
-- 
John W. Linville
linville@tuxdriver.com
