Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51686 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab2EKJSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 05:18:08 -0400
Message-ID: <4FACD94A.2070002@qca.qualcomm.com> (sfid-20120511_111812_563555_196AD1B1)
Date: Fri, 11 May 2012 12:18:02 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Use correct max-scan-SSIDs limit
References: <20120509191451.GA5835@jouni.qca.qualcomm.com>
In-Reply-To: <20120509191451.GA5835@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/2012 10:14 PM, Jouni Malinen wrote:
> The currently used firmware images support 16 SSIDs in the scan
> request (indexes 0..15), so update the host driver to use the same
> limit to allow some more SSIDs to be scanned per request. In addition,
> change the max-index to max-SSIDs to make it easier to understand the
> implementation and fix couple of off-by-one checks that could limit
> the maximum number of entries too strictly.
> 
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>

Thanks, applied.

Kalle
