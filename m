Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44161 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab2AESkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 13:40:33 -0500
Message-ID: <4F05EE77.4010509@qca.qualcomm.com> (sfid-20120105_194039_089602_DE54F742)
Date: Thu, 5 Jan 2012 20:39:51 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: revert USB support
References: <1325774738-12588-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1325774738-12588-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2012 04:45 PM, John W. Linville wrote:
> The ath6kl is causing build failures when the ath6kl bits are not built
> as modules.  A better fix is forthcoming in a future release, but for
> now lets revert the problematic code.
> 
> This reverts the following commits:
> 
> 	fde57764ef8751b9aca11b6f6221ac5555bda699.
> 	d70385a26ad9a122a5450d066550470107b6bc38.
> 	59d954dda4b9b3f3e61d4b87a2b26952b8c4c09d.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> These bits can come back in combination with the build fixes Kalle has
> been creating.  I'll leave it to Kalle to keep track of reinstating
> these bits...

Ok, I will handle this in ath6kl.git and add back the usb code once I
have commited the proper build fix (ath6kl_core.ko). The next ath6kl
merge request (after the merge window) will have the USB support again.

Kalle
