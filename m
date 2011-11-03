Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32275 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932995Ab1KCRFf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 13:05:35 -0400
Message-ID: <4EB2C9DA.10905@qca.qualcomm.com> (sfid-20111103_180538_409457_D0FEF61C)
Date: Thu, 3 Nov 2011 19:05:30 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] ath6kl: Fix key configuration to copy at most seq_len
 from seq
References: <20111102214555.GA31245@jouni.qca.qualcomm.com>
In-Reply-To: <20111102214555.GA31245@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/02/2011 11:45 PM, Jouni Malinen wrote:
> There is no guarantee on the caller using 8-octet buffer for
> key->seq, so better follow the key->seq_len parameter on figuring
> out how many octets to copy.

Thanks, I applied this patch. As discussed privately, "2/3" was just a
leftover and I ignored it.

Kalle
