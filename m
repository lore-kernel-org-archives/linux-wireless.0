Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4176 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1LMMm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 07:42:29 -0500
Message-ID: <4EE7482C.3030805@qca.qualcomm.com> (sfid-20111213_134233_214813_F15602B7)
Date: Tue, 13 Dec 2011 14:42:20 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Use delayed key configuration for WAPI in AP
 mode
References: <20111208145030.GA1131@jouni.qca.qualcomm.com>
In-Reply-To: <20111208145030.GA1131@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/08/2011 04:50 PM, Jouni Malinen wrote:
> This is needed to allow WAPI AP to configure the initial group key
> to the target in the same way as is done with TKIP/CCMP. This
> fixes broadcast data frame delivery with the initial group key.
> 
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>

Thanks, applied.

Kalle
