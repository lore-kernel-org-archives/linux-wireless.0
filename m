Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:31856 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab0JRObd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 10:31:33 -0400
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id o9IEVV39021723
	for <linux-wireless@vger.kernel.org>; Mon, 18 Oct 2010 17:31:31 +0300
Subject: Re: [PATCH v2] wl1271: Fix warning about unsupported RX rate
From: Luciano Coelho <luciano.coelho@nokia.com>
To: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1287046804-19356-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
References: <1287046804-19356-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 17:31:29 +0300
Message-ID: <1287412289.20107.66.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-14 at 11:00 +0200, Teemu Paasikivi wrote:
> While scanning, it is possible that beacon and probe response frames are
> received on other band than configured to the driver. In rx status
> handling this has caused "Unsupported RX rate from HW" warnings. This
> patch changes the wl1271_rate_to_index function to take the band of the
> received frame as a parameter instead of using value configuret to
> wl->band.
> 
> Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
> ---

Applied, thanks!


-- 
Cheers,
Luca.

