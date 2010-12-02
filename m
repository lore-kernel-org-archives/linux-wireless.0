Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:56498 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123Ab0LBOh2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 09:37:28 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-da02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oB2EbRJ2019518
	for <linux-wireless@vger.kernel.org>; Thu, 2 Dec 2010 16:37:27 +0200
Subject: Re: [PATCH] wl1271: Add wl1271_load_firmware() and export some
 functions
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Roger Quadros <roger.quadros@nokia.com>
In-Reply-To: <1291146748-8565-1-git-send-email-luciano.coelho@nokia.com>
References: <1291146748-8565-1-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 16:38:09 +0200
Message-ID: <1291300689.16140.4.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-30 at 21:52 +0200, luciano.coelho@nokia.com wrote:
> From: Roger Quadros <roger.quadros@nokia.com>
> 
> For the SDIO testing module we need to load the firmware but not
> boot it. wl1271_load_firmware() is meant to do just the firmware loading part.
> 
> We also export some functions so they are usable in the testing module.
> 
> Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> ---

Applied and pushed to wl12xx.


-- 
Cheers,
Luca.

