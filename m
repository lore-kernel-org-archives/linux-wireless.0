Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44203 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab1KCRNj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 13:13:39 -0400
Message-ID: <4EB2CA84.8080707@qca.qualcomm.com> (sfid-20111103_181343_520827_43D76A02)
Date: Thu, 3 Nov 2011 19:08:20 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Do not hide ath6kl_wmi_addkey_cmd() error values
References: <20111102214647.GA31265@jouni.qca.qualcomm.com>
In-Reply-To: <20111102214647.GA31265@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/02/2011 11:46 PM, Jouni Malinen wrote:
> Instead of converting any error to EIO, just return the real error
> value to upper layers.

Thanks, applied.

Kalle
