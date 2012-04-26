Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14051 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab2DZMDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 08:03:46 -0400
Message-ID: <4F99399C.7000201@qca.qualcomm.com> (sfid-20120426_140549_131373_4DC70199)
Date: Thu, 26 Apr 2012 15:03:40 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v3] ath6kl: Multicast filter support in wow suspend and
 non-suspend
References: <1334951216-13792-1-git-send-email-ngangadh@qca.qualcomm.com>
In-Reply-To: <1334951216-13792-1-git-send-email-ngangadh@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/20/2012 10:46 PM, Naveen Gangadharan wrote:
> This patch enables all multicast packets in non suspend mode
> and enable multicast filtering in wow suspend mode. This also
> fixes a bug in multicast where the driver assumed disable
> multicast-all command disabled/filtered all multicast
> packets, which was wrong assumption, because firmware will
> apply the programmed filter.
> 
> Multicast requirements
>  - Enable forward all multicast packets(no filtering) in
>       non suspend mode.
>  - Enable multicast filtering in wow suspend mode for both
>       AP and CLIENT.
> 
> Signed-off-by: Naveen Gangadharan <ngangadh@qca.qualcomm.com>

Thanks, applied. I just fixed one checkpatch warning.

Kalle
