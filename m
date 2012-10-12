Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15915 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759050Ab2JLMTv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 08:19:51 -0400
To: Pandiyarajan Pitchaimuthu <c_ppitch@qti.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Message-ID: <50780AE2.5020506@qca.qualcomm.com> (sfid-20121012_141956_142582_7F2A6BD2)
Date: Fri, 12 Oct 2012 15:19:46 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] ath6kl: Blocked client notification
References: <1348220333-5466-1-git-send-email-c_ppitch@qca.qualcomm.com>
In-Reply-To: <1348220333-5466-1-git-send-email-c_ppitch@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2012 12:38 PM, Pandiyarajan Pitchaimuthu wrote:
> When a station tries to connect to an AP and if the MAC of the
> station is in the AP's block list, the station cannot connect to the
> AP. This is notified to the userspace with event 
> NL80211_CMD_CONN_FAILED and attribute NL80211_ATTR_CONN_FAILED_REASON.
> The reason sent will be NL80211_CONN_FAIL_BLOCKED_CLIENT.
> 
> Signed-off-by: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>

Thanks, applied.

Kalle
