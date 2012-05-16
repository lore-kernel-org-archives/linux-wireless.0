Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45032 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760765Ab2EPXqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 19:46:45 -0400
From: "Mehta, Vipin" <vipimeht@qca.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"Gangadharan, Naveen" <ngangadh@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>
Subject: RE: [PATCH] ath6kl: Add wow multicast firmware capability support
Date: Wed, 16 May 2012 23:46:39 +0000
Message-ID: <1BD89E1E9E29A842B7BB2C01597E84E201B934DE@nasanexd02d.na.qualcomm.com> (sfid-20120517_014650_163547_34961B9C)
References: <1336771149-17063-1-git-send-email-ngangadh@qca.qualcomm.com>
 <4FB0AB4B.4000105@qca.qualcomm.com>
In-Reply-To: <4FB0AB4B.4000105@qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Naveen,
    Do we need to have this patch applied for 8x25-CS?

Vipin

-----Original Message-----
From: Valo, Kalle 
Sent: Sunday, May 13, 2012 11:51 PM
To: Gangadharan, Naveen
Cc: linux-wireless@vger.kernel.org; ath6kl-devel
Subject: Re: [PATCH] ath6kl: Add wow multicast firmware capability support

On 05/12/2012 12:19 AM, Naveen Gangadharan wrote:
> Infrastructure to enable Multicast WOW support based on firmware 
> capability added to the driver.This enables different customers or 
> chips to control this feature based on firmware capability.
> 
> kvalo: Firmware capability infrastructure for multicast wow feature.
> 
> Signed-off-by: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Thanks, applied with some indentation fixes.

Kalle
