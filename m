Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54010 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab2JLMaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 08:30:09 -0400
To: Pandiyarajan Pitchaimuthu <c_ppitch@qti.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Message-ID: <50780D3B.7080200@qca.qualcomm.com> (sfid-20121012_143014_119900_C232106F)
Date: Fri, 12 Oct 2012 15:29:47 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] ath6kl: Check for valid endpoint ID
References: <1348238589-9747-1-git-send-email-c_ppitch@qca.qualcomm.com>
In-Reply-To: <1348238589-9747-1-git-send-email-c_ppitch@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2012 05:43 PM, Pandiyarajan Pitchaimuthu wrote:
> Endpoint ID is checked to make sure it is valid.
> 
> Signed-off-by: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>

Thanks, applied. I just changed the patch title to "ath6kl: Check for
valid endpoint ID in ath6kl_tx_complete()" to make it easier to identify.

Kalle
