Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40481 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab2AXLpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 06:45:49 -0500
Message-ID: <4F1E99E2.2020600@qca.qualcomm.com> (sfid-20120124_124552_747892_9606D825)
Date: Tue, 24 Jan 2012 13:45:38 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v2 6/8] ath6kl: Return a proper error code when not in
 connected state
References: <1327066544-23779-1-git-send-email-rmani@qca.qualcomm.com> <1327066544-23779-7-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1327066544-23779-7-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2012 03:35 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> Error code ENOTCONN is more suitable than EINVAL to report
> when the driver is not in connected state in ath6kl_wow_suspend().
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

Does this fix a visible bug? Or did you find this during code review?

Kalle
