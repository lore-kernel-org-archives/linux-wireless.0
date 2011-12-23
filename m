Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28324 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab1LWMr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 07:47:27 -0500
Message-ID: <4EF47797.5010307@qca.qualcomm.com> (sfid-20111223_134731_745532_0F8C1E54)
Date: Fri, 23 Dec 2011 14:44:07 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Dai Shuibing <shuibing@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Fix connect command to clear previously used
 IEs
References: <20111215121600.GA16588@jouni.qca.qualcomm.com>
In-Reply-To: <20111215121600.GA16588@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/15/2011 02:16 PM, Jouni Malinen wrote:
> Empty IE buffer means that the new association is not supposed to
> include extra IEs. Make sure any previously configured (Re)Association
> Request frame IEs get cleared in such a case. This is based on a patch
> from Shuibing.
> 
> Cc: Dai Shuibing <shuibing@qca.qualcomm.com>
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>

Thanks, applied.

Kalle
