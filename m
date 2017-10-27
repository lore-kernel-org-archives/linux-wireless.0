Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:2635 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752489AbdJ0Nmp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 09:42:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wil6210: disallow changing RSN in beacon change
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20171017194253.10212-1-johannes@sipsolutions.net>
References: <20171017194253.10212-1-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Maya Erez <qca_merez@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>
Message-ID: <f48cbfcf31204a839d345927f712227f@euamsexm01a.eu.qualcomm.com> (sfid-20171027_154253_166974_FB71CF72)
Date: Fri, 27 Oct 2017 15:42:37 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> wrote:

> This is a code path that will never really get hit anyway, since
> it's nonsense to change the beacon of an existing BSS to suddenly
> include or no longer include the RSN IE. Reject this instead of
> having the dead code, and get rid of accessing wdev->ssid/_len by
> way of that.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

What's the conclusion, should I take this patch or drop it?

-- 
https://patchwork.kernel.org/patch/10012789/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
