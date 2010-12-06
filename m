Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33027 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab0LFVAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 16:00:05 -0500
Date: Mon, 6 Dec 2010 15:59:16 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3 v3] ath9k: Add change_interface callback
Message-ID: <20101206205916.GA21269@tuxdriver.com>
References: <1291119452-12355-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1291119452-12355-1-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 30, 2010 at 05:47:32PM +0530, Rajkumar Manoharan wrote:
> Add support to change interface type
> without bringing down the interface.
> 
> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> ---
> v2: - ieee80211_iftype_p2p not needed
>     - missed to store p2p value
> v3: - nbcnvifs has to be checked
>       while changing to beaconing mode

This just doesn't seem to apply anymore.  Could you respin it?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
