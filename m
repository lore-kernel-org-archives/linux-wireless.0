Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4718 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765883AbYBTUcB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 15:32:01 -0500
Date: Wed, 20 Feb 2008 15:09:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo Couckuyt <iv0co@yahoo.co.uk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: PROBLEM: p54usb doesn't work with my Philips CPWUA054 usb
	adapter
Message-ID: <20080220200926.GA3825@tuxdriver.com> (sfid-20080220_203224_919705_5FF0B80A)
References: <47AF79DA.10204@yahoo.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <47AF79DA.10204@yahoo.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 10, 2008 at 11:25:30PM +0100, Ivo Couckuyt wrote:

> Note that my adapter isn't in the vendor:model id list of the p54 driver, 
> my patch submitted for that is prob. lost somewhere.
> But I'm using islsm with my usb adapters for >1.5 years with no problems.
> lsusb lists my device's model/vendor id
> Bus 001 Device 002: ID 083a:5501 Accton Technology Corp.

This is the Internet, nothing is ever lost... :-)

FWIW, your old patch was against the prism54usb driver.  I retargeted
against p54usb and just posted it to this list.  I'll send it upstream
with the next round of fixes.

John
-- 
John W. Linville
linville@tuxdriver.com
