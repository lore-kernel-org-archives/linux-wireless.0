Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22845 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab2ENGvB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 02:51:01 -0400
Message-ID: <4FB0AB4B.4000105@qca.qualcomm.com> (sfid-20120514_085106_743803_4629C087)
Date: Mon, 14 May 2012 09:50:51 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Add wow multicast firmware capability support
References: <1336771149-17063-1-git-send-email-ngangadh@qca.qualcomm.com>
In-Reply-To: <1336771149-17063-1-git-send-email-ngangadh@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/12/2012 12:19 AM, Naveen Gangadharan wrote:
> Infrastructure to enable Multicast WOW support based on
> firmware capability added to the driver.This enables
> different customers or chips to control this feature based
> on firmware capability.
> 
> kvalo: Firmware capability infrastructure for multicast wow feature.
> 
> Signed-off-by: Naveen Gangadharan <ngangadh@qca.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Thanks, applied with some indentation fixes.

Kalle
