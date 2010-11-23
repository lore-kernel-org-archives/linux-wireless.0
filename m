Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55967 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745Ab0KWQg3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 11:36:29 -0500
Received: by fxm13 with SMTP id 13so4034973fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 08:36:28 -0800 (PST)
Message-ID: <4CEBED7B.9020709@lwfinger.net>
Date: Tue, 23 Nov 2010 10:36:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH] wireless: b43: fix error path in SDIO
References: <Pine.LNX.4.64.1011231709380.25676@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1011231709380.25676@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/2010 10:10 AM, Guennadi Liakhovetski wrote:
> Fix unbalanced call to sdio_release_host() on the error path.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

>From what I know about SDIO, this patch looks correct. We just fixed a similar
problem in b43_sdio_remove(). Add my ACKed-by.

John,

I think this should be in 2.6.37, and that there should be a Cc for stable.

Larry

