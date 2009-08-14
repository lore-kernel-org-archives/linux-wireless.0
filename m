Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49531 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757062AbZHNURB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 16:17:01 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] b43: LP-PHY: Implement channel switching for rev0/1/B2062 radio
Date: Fri, 14 Aug 2009 22:16:59 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A849075.7000000@gmail.com>
In-Reply-To: <4A849075.7000000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908142217.00061.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 14 August 2009 00:15:17 Gábor Stefanik wrote:
> -Move pdiv from lpphy_2062_init to struct b43_phy_lp.
> -Add channel table for the B2062 radio.
> -Add code for tuning the B2062 radio to channel.
> -Add error handling to op_switch_channel, and use it for both radios.
> 
> Rev0/1/B2062 will now hopefully show some signs of life, though
> it won't work at full performance, as calibration is still missing.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>

ack

-- 
Greetings, Michael.
