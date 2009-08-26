Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39873 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbZHZUq1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 16:46:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] ssb: Implement PMU LDO control and use it in b43
Date: Wed, 26 Aug 2009 22:46:24 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1251312686-32067-1-git-send-email-netrolller.3d@gmail.com> <1251312686-32067-2-git-send-email-netrolller.3d@gmail.com> <1251312686-32067-3-git-send-email-netrolller.3d@gmail.com>
In-Reply-To: <1251312686-32067-3-git-send-email-netrolller.3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908262246.26668.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 26 August 2009 20:51:26 Gábor Stefanik wrote:
> Implement the "PMU LDO set voltage" and "PMU LDO PA ref enable"
> functions, and use them during LP-PHY baseband init in b43.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>

ack

-- 
Greetings, Michael.
