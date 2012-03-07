Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40138 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab2CGHSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 02:18:40 -0500
Message-ID: <4F570BCB.1000702@qca.qualcomm.com> (sfid-20120307_081844_072706_E19CC839)
Date: Wed, 7 Mar 2012 09:18:35 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v2] ath6kl: Add provision to define suspend policy in
 disconnected state.
References: <1331026439-7822-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1331026439-7822-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2012 11:33 AM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> It gives flexibility to the user to define suspend policy
> when the suspend mode is set to WOW and the device is in
> disconnected state at the time of suspend.
> 
> New module parameter wow_mode is added to get the choice
> from the user. This parameter is valid only if the module
> parameter suspend_mode is set to WOW.
> 
> To force WOW in connected state and cut power
> in disconnected state:
>   suspend_mode=0x3 wow_mode=0x1
> 
> To force WOW in connected state and deep sleep
> in disconnected state:
>    suspend_mode=0x3 wow_mode=0x2
> 
> If there is no value specified to wow_mode during insmod,
> deep sleep mode will be tried in the disconnected state.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

Thanks, applied.

Kalle
