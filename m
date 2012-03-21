Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50333 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab2CUGJx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 02:09:53 -0400
Message-ID: <4F6970A8.6000707@qca.qualcomm.com> (sfid-20120321_070957_528034_76113D49)
Date: Wed, 21 Mar 2012 11:39:44 +0530
From: Raja Mani <rmani@qca.qualcomm.com>
MIME-Version: 1.0
To: shonmou li <shonmou@gmail.com>
CC: <kvalo@qca.qualcomm.com>, <ath6kl-devel@qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: avoiding 80211 scan does not complete before
 start scheduled scan.
References: <CADhJdvDbAORKoWUxLdcz7Jq2dt9DKEPzBwgmiNvZsj6iU2K9Kw@mail.gmail.com>
In-Reply-To: <CADhJdvDbAORKoWUxLdcz7Jq2dt9DKEPzBwgmiNvZsj6iU2K9Kw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested-by: Raja Mani <rmani@qca.qualcomm.com>

On Thursday 23 February 2012 09:45 PM, shonmou li wrote:
> Dear Kvalo:
>
> In this patch, i stop 80211 scan before scheduled scan.
> It could avoid the following situation it will cause wpa_supplicant
> trigger scan fail:
>
> "The device connected with access point then system goes into suspend mode.
> At this moment AP might be turned off or signal lost and then disconnect
> with the device."
>
> The attached file is my patch.
>
> --
> Best Regards,
> shonmou
