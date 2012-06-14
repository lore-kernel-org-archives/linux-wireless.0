Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63021 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab2FNK4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 06:56:52 -0400
Message-ID: <4FD9C36E.50302@qca.qualcomm.com> (sfid-20120614_125655_834291_3F07E6C4)
Date: Thu, 14 Jun 2012 13:56:46 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: fix fw capability parsing
References: <1339446972-3793-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1339446972-3793-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/2012 11:36 PM, Thomas Pedersen wrote:
> This patch fixes a bug where no capabilites are parsed when the number
> of firmware capability bits translate into fewer bytes than the host has
> knowledge of. Instead just process number of capability bytes as
> reported by the firmware.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

Thanks, applied.

Kalle
