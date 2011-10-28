Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25083 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1J1LOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 07:14:07 -0400
Message-ID: <4EAA8E70.9020308@qca.qualcomm.com> (sfid-20111028_131413_935422_6D21E8FB)
Date: Fri, 28 Oct 2011 14:13:52 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Report unique remain-on-channel cookie values
References: <20111027130013.GA32096@jouni.qca.qualcomm.com>
In-Reply-To: <20111027130013.GA32096@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/27/2011 04:00 PM, Jouni Malinen wrote:
> Even though only a single concurrent remain-on-channel operation is
> supported, there may be two pending remain-on-channel events (one to
> indicate end of a canceled operation and another to indicate start of a
> new operation). User space won't be able to distinguish these events
> unless unique cookies are used.
> 
> The previous behavior resulted in wpa_supplicant getting quite
> confused about the driver's offchannel state in various sequences
> and this made the P2P state machine behave incorrectly. Use of
> more than a single remain-on-channel cookie value fixes this.

Thanks, applied.

Kalle
