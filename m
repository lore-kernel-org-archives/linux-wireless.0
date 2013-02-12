Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:50520 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758609Ab3BLJY3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 04:24:29 -0500
Message-ID: <511A0A4B.6010507@lri.fr> (sfid-20130212_102441_508885_F0FBEC71)
Date: Tue, 12 Feb 2013 10:24:27 +0100
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] ath9k: Fix IBSS joiner mode
References: <1359972504-8900-1-git-send-email-sujith@msujith.org> <1359972504-8900-3-git-send-email-sujith@msujith.org>
In-Reply-To: <1359972504-8900-3-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/02/2013 11:08, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> On joining an existing IBSS network, beaconing has to start
> only after a TSF sync has happened by receiving a beacon from
> the BSS. In creator mode, beaconing can start immediately after
> a HW reset has been done.
> 
> Now that mac80211 notifies the driver of the mode type (creator/joiner)
> via ieee80211_bss_conf->ibss_creator, make use of it to properly setup
> the HW beacon timers.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---

Even though my IBSS network isn't as large as it was when i experienced
the most severe problems, i see no stuck beacon now; the network is much
more reliable.

Thanks.

Tested-by: Nicolas Cavallari <nicolas.cavallari@lri.fr>
