Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2343 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab1J1LWK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 07:22:10 -0400
Message-ID: <4EAA905B.8080705@qca.qualcomm.com> (sfid-20111028_132218_916824_CB3193DF)
Date: Fri, 28 Oct 2011 14:22:03 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/10] ath6kl: don't use cfg80211_scan_request after	cfg80211_scan_done()
References: <20111027154746.23519.39680.stgit@localhost6.localdomain6>
In-Reply-To: <20111027154746.23519.39680.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/27/2011 06:47 PM, Kalle Valo wrote:
> Use of cfg80211_scan_request is not valid after calling cfg80211_scan_done()
> but ath6kl_cfg80211_scan_complete_event() was doing exactly that. Change
> the function to call cfg80211_scan_done() last.
> 
> This was found during code review, I didn't see any visible problems
> due to this bug.

All 10 applied.

Kalle
