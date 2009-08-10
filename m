Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35874 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbZHJTC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 15:02:28 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH V2] b43: Update LP-PHY rev2+ baseband init to match the specs
Date: Mon, 10 Aug 2009 21:02:26 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A806D82.4010606@gmail.com>
In-Reply-To: <4A806D82.4010606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908102102.26416.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 August 2009 20:57:06 Gábor Stefanik wrote:
> The rev2+ BB init spec has changed behind us, and thus the code is
> no longer up to date. Update the code to match the current specs.
> Also implement save/restore dig filt state, as required by the
> new specification.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> V2: use ARRAY_SIZE for loop counts.

ack

-- 
Greetings, Michael.
