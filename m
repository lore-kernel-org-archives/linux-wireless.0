Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:43677 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227Ab0ENIXi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 04:23:38 -0400
Subject: Re: [PATCH] wl1271: remove sdio ARM dependency
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1273743804-11587-1-git-send-email-ohad@wizery.com>
References: <1273743804-11587-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 11:23:41 +0300
Message-ID: <1273825421.6318.98.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-13 at 11:43 +0200, ext Ohad Ben-Cohen wrote:
> Make it possible to use wl1271's SDIO interface on non-ARM platforms.
> 
> Fully tested on a x86 platform, compile-tested on ARM.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>

One question, what wl1271 card are you using on an x86 platform?

-- 
Cheers,
Luca.

