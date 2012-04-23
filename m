Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:65448 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab2DWLbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 07:31:38 -0400
Message-ID: <4F953D94.6090608@qca.qualcomm.com> (sfid-20120423_133142_025310_45F64847)
Date: Mon, 23 Apr 2012 14:31:32 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: disallow WoW with multiple vifs
References: <1334878159-7713-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1334878159-7713-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/20/2012 02:29 AM, Thomas Pedersen wrote:
> The ath6kl fw does not have enough memory to support the WoW filters of
> more than one vif. Disallow WoW suspend if this is the case.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

Thanks, applied.

Kalle
