Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.newmedia-net.de ([185.84.6.166]:44755 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbeHONI1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 09:08:27 -0400
Subject: Re: [PATCH 3/3] ath10k: Add support to configure ftm responder role
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
 <1534293018-4930-4-git-send-email-pradeepc@codeaurora.org>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <36962f12-84ff-d1a9-8273-a8e3444db108@dd-wrt.com> (sfid-20180815_121657_919489_EA4C3C19)
Date: Wed, 15 Aug 2018 12:16:50 +0200
MIME-Version: 1.0
In-Reply-To: <1534293018-4930-4-git-send-email-pradeepc@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Am 15.08.2018 um 02:30 schrieb Pradeep Kumar Chitrapu:
>   
> +	if (test_bit(WMI_SERVICE_RTT, ar->wmi.svc_map))
> +		wiphy_ext_feature_set(ar->hw->wiphy,
> +				      NL80211_EXT_FEATURE_SET_FTM_RESPONDER);
> +

not sure if this is accurate. even if WMI_SERVICE_RTT is set, the 
firmware may not support this feature. this feature doesnt seem to be 
implemented in current firmware releases
i checked the firmware sourcecode i have from 3.4 series and it doesnt 
support this feature


Sebastian
