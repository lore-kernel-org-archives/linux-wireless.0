Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53506 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab2AIKpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 05:45:16 -0500
Message-ID: <4F0AC533.70308@qca.qualcomm.com> (sfid-20120109_114521_490583_CC4335D1)
Date: Mon, 9 Jan 2012 12:45:07 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH V2 3/3] ath6kl: Remove deadcode in main.c
References: <1325584142-6746-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1325584142-6746-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/03/2012 11:49 AM, Vasanthakumar Thiagarajan wrote:
> In ath6kl_reset_device(), since control can never reach switch..case
> when the target_type is neither TARGET_TYPE_AR6003 nor TARGET_TYPE_AR6004,
> remove the default option of switch statement.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, applied.

Kalle
