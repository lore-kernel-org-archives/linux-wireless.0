Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43689 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab2AIRxP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 12:53:15 -0500
Message-ID: <4F0B2946.4040503@qca.qualcomm.com> (sfid-20120109_185318_984263_D10FD880)
Date: Mon, 9 Jan 2012 19:52:06 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/8] Allow the user to define suspend mode
References: <1326098182-9103-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1326098182-9103-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2012 10:36 AM, rmani@qca.qualcomm.com wrote:

> This series of patch enables the user to specify the suspend mode 
> via module parameter (suspend_mode) while doing insmod of the driver.
> 
>    To select Cut Power mode:
>       insmod ath6kl_sdio.ko suspend_mode = 1
> 
>    To select Deep Sleep mode:
>       insmod ath6kl_sdio.ko suspend_mode = 2
> 
>    To select WOW suspend mode:
>       insmod ath6kl_sdio.ko suspend_mode = 3
> 
> Existing module param 'suspend_cutpower' variable is renamed to 
> 'suspend_mode' for this purspose.

I'm not sure about this one. In a way this makes sense so that user can
force the particular suspend mode, but on the other hand I'm not sure if
this is a bit too much.

J&J (John and Johannes), what do you think? Is this acceptable?

Kalle
