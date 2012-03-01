Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58864 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757327Ab2CAGef (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 01:34:35 -0500
Message-ID: <4F4F1875.8050108@qca.qualcomm.com> (sfid-20120301_073438_424803_C3D0F6BA)
Date: Thu, 1 Mar 2012 08:34:29 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Make sure wiphy is registered before calling
 regulatory_hint()
References: <1330161197-8593-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1330161197-8593-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2012 11:13 AM, Vasanthakumar Thiagarajan wrote:
> As regulatory events are processed even before the wiphy is registered,
> calling regulatory_hint() at early stage should be fixed.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, applied.

Kalle
