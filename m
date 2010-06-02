Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:51934 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932918Ab0FBWzi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 18:55:38 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 02 Jun 2010 15:55:38 -0700
Date: Wed, 2 Jun 2010 15:55:36 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2] ath9k: Enable Short GI in 20 Mhz for ar9287 and
 later chips
Message-ID: <20100602225535.GA2275@vasanth-laptop>
References: <1275503034-5794-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1275503034-5794-1-git-send-email-vasanth@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 02, 2010 at 11:53:54PM +0530, Vasanthakumar Thiagarajan wrote:
> This patch enables short GI rx at all rates and tx at mcs15
> for 20 Mhz channel width also.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
> 
> V2 Update respective rate count

Please ignore this v2, i've sent a separate patch fixing this
bug.

Vasanth
