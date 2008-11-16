Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:40786 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752214AbYKPPfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 10:35:08 -0500
Message-ID: <49203DAA.3000102@lwfinger.net> (sfid-20081116_163514_051320_224E2FBE)
Date: Sun, 16 Nov 2008 09:35:06 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 3/4] p54pci: cache firmware for suspend/resume v2.1
References: <200811141941.56752.chunkeey@web.de> <200811150142.28447.chunkeey@web.de> <200811151930.19854.chunkeey@web.de> <200811161220.32828.chunkeey@web.de>
In-Reply-To: <200811161220.32828.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> Johannes pointed out that the driver has cache the firmware for
> suspend/resume cycles. 
>  
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> v1 removed a bit too much. it was very chatty about the firmware capabilities...
> v2 forget release_firmware. d'oh!

Christian,

When you post updated versions, please indicate them in the subject line, as in
"[PATCH 3/4 V3] ...." or a similar indication. When several versions have the
same subject, it gets hard to keep them separate.

Thanks,

Larry
