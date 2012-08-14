Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30588 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab2HNFCz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 01:02:55 -0400
Message-ID: <5029DBF7.8060402@qca.qualcomm.com> (sfid-20120814_070303_866413_C3427170)
Date: Tue, 14 Aug 2012 10:32:47 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC 3/3] ath9k_htc: Remove interface combination specific checks
References: <1344871392-6642-1-git-send-email-mohammed@qca.qualcomm.com> <20521.8077.412278.460752@gargle.gargle.HOWL>
In-Reply-To: <20521.8077.412278.460752@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 13 August 2012 09:08 PM, Sujith Manoharan wrote:
> Mohammed Shafi Shajakhan wrote:
>> -	if (priv->nvifs >= ATH9K_HTC_MAX_VIF) {
>> -		mutex_unlock(&priv->mutex);
>> -		return -ENOBUFS;
>> -	}
>> -
>> -	if (priv->num_ibss_vif ||
>> -	    (priv->nvifs && vif->type == NL80211_IFTYPE_ADHOC)) {
>> -		ath_err(common, "IBSS coexistence with other modes is not allowed\n");
>> -		mutex_unlock(&priv->mutex);
>> -		return -ENOBUFS;
>> -	}
>> -
>> -	if (((vif->type == NL80211_IFTYPE_AP) ||
>> -	     (vif->type == NL80211_IFTYPE_ADHOC)) &&
>> -	    ((priv->num_ap_vif + priv->num_ibss_vif) >= ATH9K_HTC_MAX_BCN_VIF)) {
>> -		ath_err(common, "Max. number of beaconing interfaces reached\n");
>> -		mutex_unlock(&priv->mutex);
>> -		return -ENOBUFS;
>> -	}
>> -
>
> Looks okay.

thanks for the review!


>
> Sujith
>


-- 
thanks,
shafi


