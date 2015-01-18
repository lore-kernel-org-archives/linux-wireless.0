Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vps0.lunn.ch ([178.209.37.122]:57447 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbbARQ0e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 11:26:34 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.80)
	(envelope-from <andrew@lunn.ch>)
	id 1YCseM-0004DI-9D
	for linux-wireless@vger.kernel.org; Sun, 18 Jan 2015 17:24:30 +0100
Date: Sun, 18 Jan 2015 17:24:30 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: linux-wireless@vger.kernel.org
Subject: Firmware for Marvell SD8786?
Message-ID: <20150118162430.GF19604@lunn.ch> (sfid-20150118_172637_694798_CC77FC07)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Folks

Is there a firmware somewhere for the Marvell SD8786 device?

There is nothing in the linux firmware tree. I found one old firmware
image which works for kernels around 3.5, but since then, it appears
the mwifiex driver has gained some regressions with respect to this
firmware.

Thanks
	Andrew
