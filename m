Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58235 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab2GSJWS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 05:22:18 -0400
Message-ID: <5007D1C5.1050501@qca.qualcomm.com> (sfid-20120719_112221_992477_D8D729D5)
Date: Thu, 19 Jul 2012 12:22:13 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath6kl: support TX error rate notification
References: <1342579195-18521-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1342579195-18521-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/18/2012 05:39 AM, Thomas Pedersen wrote:
> The ath6kl firmware can monitor a connection and report when a certain
> TX failure threshold is crossed. Support this configuration and event
> reporting on compatible firmwares.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

Thanks, applied.

Kalle
