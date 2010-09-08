Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:64075 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab0IHSBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 14:01:00 -0400
Subject: Re: [PATCH] wl1271: sdio: claim host only when doing IO
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1283822661-16018-1-git-send-email-ohad@wizery.com>
References: <1283822661-16018-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Sep 2010 11:00:32 -0700
Message-ID: <1283968832.9120.23.camel@capsicum>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-07 at 03:24 +0200, ext Ohad Ben-Cohen wrote:
> Do not maintain a persistent sdio_claim_host state. Instead,
> claim host before doing IO and release host soon after.
> 
> This fixes several mmc deadlock scenarios, e.g. during
> suspend/resume.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---

Looks reasonable.  Thanks!

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>


-- 
Cheers,
Luca.

