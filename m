Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21145 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab2DRKL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 06:11:56 -0400
Message-ID: <4F8E9368.4000004@qca.qualcomm.com> (sfid-20120418_121200_834238_7EFE5600)
Date: Wed, 18 Apr 2012 13:11:52 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Remove incorrect Probe Response offload support
 for Interworking
References: <20120416162535.GA9636@jouni.qca.qualcomm.com>
In-Reply-To: <20120416162535.GA9636@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 07:25 PM, Jouni Malinen wrote:
> ath6kl does not support Probe Response offloading for Interworking (IEEE
> 802.11u), so remove the incorrectly added capability flag for it.
> 
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>

Thanks, applied.

Kalle
