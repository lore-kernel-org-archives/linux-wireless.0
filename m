Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38920 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZHPNmo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2009 09:42:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] b43: LP-PHY: Update code for spec fixes, and fix a few typos
Date: Sun, 16 Aug 2009 15:42:41 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A88090D.3070107@gmail.com>
In-Reply-To: <4A88090D.3070107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908161542.41775.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 16 August 2009 15:26:37 Gábor Stefanik wrote:
> A few typos have been discovered both in the specs in and our code.
> This patch fixes them.
> 
> Also use lpphy_op_switch_channel consistently, and make all callers
> print its return value for easier debugging.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> I think using a forward declaration is justified in this case;
> as avoiding the forward decl would require moving around huge
> blocks of code, completely breaking any logical ordering.

I don't think so, but I'll ack this anyway.

-- 
Greetings, Michael.
