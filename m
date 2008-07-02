Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36237 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbYGBVE1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 17:04:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + drivers-net-wireless-b43legacy-dmac-remove-the-switch-in-b43legacy_dma_init.patch added to -mm tree
Date: Wed, 2 Jul 2008 23:03:49 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Adrian Bunk <bunk@kernel.org>, dhowells@redhat.com,
	linville@tuxdriver.com, stefano.brivio@polimi.it,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
References: <200807020835.m628Zx2e007473@imap1.linux-foundation.org> <486BB332.6000703@lwfinger.net> <20080702101650.3f579d21.akpm@linux-foundation.org>
In-Reply-To: <20080702101650.3f579d21.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807022303.50142.mb@bu3sch.de> (sfid-20080702_230431_340923_983F8345)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 02 July 2008 19:16:50 Andrew Morton wrote:
> I don't think we need to fix this in 2.6.26 - I doubt if anyone uses
> this driver on frv - it's mainly a "make allmodconfig work on FRV"
> thing.

I fully agree.


-- 
Greetings Michael.
