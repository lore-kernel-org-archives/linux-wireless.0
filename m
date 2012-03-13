Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57883 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab2CMMqu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 08:46:50 -0400
Message-ID: <4F5F41B5.1040108@qca.qualcomm.com> (sfid-20120313_134702_226503_BE4C4AD5)
Date: Tue, 13 Mar 2012 14:46:45 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: fix debug.c file mode
References: <1331642325-27729-1-git-send-email-kvalo@qca.qualcomm.com>
In-Reply-To: <1331642325-27729-1-git-send-email-kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/13/2012 02:38 PM, Kalle Valo wrote:
> Commit 7504a3e1 ("ath6kl: add padding to firmware log records") accidentally
> changed debug.c mode from 100644 to 100755. Revert that back to original.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied.

Kalle
