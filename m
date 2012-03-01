Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25703 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab2CAGsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 01:48:23 -0500
Message-ID: <4F4F1BB2.4090701@qca.qualcomm.com> (sfid-20120301_074827_149518_9BFA4C9A)
Date: Thu, 1 Mar 2012 08:48:18 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Etay Luz <eluz@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Collect residue firmware logs
References: <1330478284-29968-1-git-send-email-eluz@qca.qualcomm.com>
In-Reply-To: <1330478284-29968-1-git-send-email-eluz@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/29/2012 03:18 AM, Etay Luz wrote:
> Collect residue firmware logs following firmware assert.
> Firmware sends logs to host once the 1500 byte log buffer
> has been filled. At time of assert, there could be residue
> logs lying in the firmware. This patch pulls those residue
> logs. This would give the full picture of the firmware.
> 
> Signed-off-by: Etay Luz <eluz@qca.qualcomm.com>

Thanks, applied.

Kalle
