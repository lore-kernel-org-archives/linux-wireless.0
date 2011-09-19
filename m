Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37673 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab1ISHC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 03:02:59 -0400
Message-ID: <4E76E917.9020300@qca.qualcomm.com> (sfid-20110919_090312_903282_84743492)
Date: Mon, 19 Sep 2011 10:02:47 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Fix static WEP configuration in AP mode
References: <20110915121016.GA9230@jouni.qca.qualcomm.com>
In-Reply-To: <20110915121016.GA9230@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2011 03:10 PM, Jouni Malinen wrote:
> Configuration of the WEP keys needs to be delayed until the AP mode has
> been properly started at the target. Partial support for delaying the
> WEP key configuration was already in place in the driver, but the actual
> part of deciding when to do this was missing.

Thanks, applied.

Kalle
