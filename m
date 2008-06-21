Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:42535 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbYFUJbA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2008 05:31:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] ssb, b43, b43legacy, b44: Rewrite SSB DMA API
Date: Sat, 21 Jun 2008 11:30:11 +0200
Cc: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200806201150.29497.mb@bu3sch.de> <485C45D2.1050106@lwfinger.net>
In-Reply-To: <485C45D2.1050106@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806211130.11609.mb@bu3sch.de> (sfid-20080621_113108_367048_5D7964EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 21 June 2008 02:05:38 Larry Finger wrote:
> Is there a pre-requisite for this patch?

[PATCH] b43legacy: Fix possible NULL pointer dereference in DMA code

-- 
Greetings Michael.
