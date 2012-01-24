Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53803 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab2AXMkG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 07:40:06 -0500
Message-ID: <4F1EA5F0.50908@qca.qualcomm.com> (sfid-20120124_134011_809014_B769B69A)
Date: Tue, 24 Jan 2012 14:37:04 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH V2 1/6] ath6kl: Make sure to delete rx aggregation timer
 in aggr_reset_state()
References: <1327139573-7435-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1327139573-7435-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/21/2012 11:52 AM, Vasanthakumar Thiagarajan wrote:
> The timer which is used to flush rx aggregation frames needs to
> be disabled when resetting the aggregation state. This is found
> in code review.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, all six patches applied.

Kalle
