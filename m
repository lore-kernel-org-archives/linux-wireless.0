Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41211 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab2IUQqN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 12:46:13 -0400
Message-ID: <505C99D0.8090106@qca.qualcomm.com> (sfid-20120921_184627_578341_2BCB9D8B)
Date: Fri, 21 Sep 2012 19:46:08 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v2 1/3] ath6kl: Avoid null ptr dereference while printing
 reg domain pair
References: <1348220335-29711-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1348220335-29711-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2012 12:38 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> Return value of ath6kl_get_regpair() is stored in 'regpair' in
> ath6kl_wmi_regdomain_event() func and it's directly accessed
> in the debug prints without checking for NULL value. There are
> situation to get NULL pointer as a return value from
> ath6kl_get_regpair() func. Fix this.
> 
> Found this on code review.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

Thanks, all three patches applied.

Kalle
