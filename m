Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59158 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab2DLHh4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 03:37:56 -0400
Message-ID: <4F86864F.9010605@qca.qualcomm.com> (sfid-20120412_093759_472780_CB1E3CB4)
Date: Thu, 12 Apr 2012 10:37:51 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Configure 0 as rsn cap when it is not there in
 rsn ie
References: <1334048267-27256-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1334048267-27256-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/10/2012 11:57 AM, Vasanthakumar Thiagarajan wrote:
> Currently rsn capability is not set when it is not available in
> rsn IE. Set it to 0 in firmware when it is not there in the ie to
> make sure host and target are consistent.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, applied.

Kalle
