Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5831 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab1KXMbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 07:31:09 -0500
Message-ID: <4ECE3909.5020509@qca.qualcomm.com> (sfid-20111124_133113_744179_21C2FB8F)
Date: Thu, 24 Nov 2011 14:31:05 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 2/5] ath6kl: fix ath6kl's set tx power
References: <1322064494-16427-1-git-send-email-mcgrof@qca.qualcomm.com>
In-Reply-To: <1322064494-16427-1-git-send-email-mcgrof@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/2011 06:08 PM, Luis R. Rodriguez wrote:
> ath6kl assumed cfg80211 passed to us power in dBm but it is in mBm.
> 
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

Thanks, applied.

Kalle
