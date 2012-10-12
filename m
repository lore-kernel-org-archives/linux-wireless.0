Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20231 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab2JLMIz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 08:08:55 -0400
To: Pandiyarajan Pitchaimuthu <c_ppitch@qti.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Message-ID: <50780841.6080608@qca.qualcomm.com> (sfid-20121012_140859_617798_E6A525EB)
Date: Fri, 12 Oct 2012 15:08:33 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] ath6kl: Max clients reached notification
References: <1348220174-5324-1-git-send-email-c_ppitch@qca.qualcomm.com>
In-Reply-To: <1348220174-5324-1-git-send-email-c_ppitch@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2012 12:36 PM, Pandiyarajan Pitchaimuthu wrote:
> When a station requests connection to an AP, that has already been
> connected to the maximum number of stations it can support, an event
> is sent to user space via NL80211_CMD_CONN_FAILED command and reason
> attribute NL80211_ATTR_CONN_FAILED_REASON with
> NL80211_CONN_FAIL_MAX_CLIENTS as reason.
> 
> Signed-off-by: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>

Thanks, applied.

Kalle
