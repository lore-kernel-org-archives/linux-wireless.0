Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52241 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab2CAGlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 01:41:52 -0500
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Message-ID: <4F4F1A2C.2080204@qca.qualcomm.com> (sfid-20120301_074156_390442_DB4DCAE5)
Date: Thu, 1 Mar 2012 08:41:48 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: implement hidden ssid
References: <1330470526-8155-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1330470526-8155-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/29/2012 01:08 AM, Thomas Pedersen wrote:
> The ath6kl FW does not distinguish between different types of hidden
> SSIDs (empty or null), so treat all cfg80211 requests for hidden ssid
> the same.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

Thanks, applied.

Kalle
