Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27777 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab1IAJTx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:19:53 -0400
Message-ID: <4E5F4E35.3080208@qca.qualcomm.com> (sfid-20110901_111958_155445_4AA7E5EB)
Date: Thu, 1 Sep 2011 12:19:49 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Do not enable Probe Request reporting by default
References: <20110901083320.GA2007@jouni.qca.qualcomm.com>
In-Reply-To: <20110901083320.GA2007@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/01/2011 11:33 AM, Jouni Malinen wrote:
> Probe Request reporting will be needed for P2P and WPS, but some
> firmware builds do not seem to like this when P2P is not enabled.
> Since we do not yet enable P2P, the safest option here is to just
> remove this call for now and bring it back as a more dynamic version
> once ath6kl starts advertising support for P2P.

Thanks, applied to my local ath6kl.git.

Kalle
