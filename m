Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37656 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623AbbI2III (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 04:08:08 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v3,1/2] airo: fix IW_AUTH_ALG_OPEN_SYSTEM
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1442843065-30234-1-git-send-email-linux@rainbow-software.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	netdev@vger.kernel.org,
	Kernel development list <linux-kernel@vger.kernel.org>
Message-Id: <20150929080807.80C6D13F6A5@smtp.codeaurora.org> (sfid-20150929_100815_500543_E6DFE22F)
Date: Tue, 29 Sep 2015 08:08:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> IW_AUTH_ALG_OPEN_SYSTEM is ambiguous in set_auth for WEP as
> wpa_supplicant uses it for both no encryption and WEP open system.
> Cache the last mode set (only of these two) and use it here.
> 
> This allows wpa_supplicant to work with unencrypted APs.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Thanks, 2 patches applied to wireless-drivers-next.git:

4a0f2ea79797 airo: fix IW_AUTH_ALG_OPEN_SYSTEM
2b8fa9e870b7 airo: Implement netif_carrier_on/off

Kalle Valo
