Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46429 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbZHMNMp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 09:12:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] b43: Update dummy transmission to match V4 specs
Date: Thu, 13 Aug 2009 15:12:44 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A832890.9010408@gmail.com>
In-Reply-To: <4A832890.9010408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908131512.45006.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 August 2009 22:39:44 Gábor Stefanik wrote:
> The V4 dummy transmission function has two extra bools in its
> prototype, so add a wrapper function for callers that expect the
> V3 version.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>

Nah, please just convert all callers instead. There are not that many callers.
It's maybe about 10.

-- 
Greetings, Michael.
