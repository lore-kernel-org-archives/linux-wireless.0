Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26299 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813Ab1IBJMR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 05:12:17 -0400
Message-ID: <4E609DEC.6060508@qca.qualcomm.com> (sfid-20110902_111221_031966_56FC0078)
Date: Fri, 2 Sep 2011 12:12:12 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath6kl: Fix endianness in requesting chip register
 read
References: <1314785895-18808-1-git-send-email-vthiagar@qca.qualcomm.com> <1314785895-18808-2-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1314785895-18808-2-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/31/2011 01:18 PM, Vasanthakumar Thiagarajan wrote:
> Need to make sure the chip address for which we need the value
> si endian safe.

Thanks, applied.

Kalle
