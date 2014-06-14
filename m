Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:50308 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbaFNIAp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2014 04:00:45 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org,
	Max Stepanov <Max.Stepanov@intel.com>
Subject: Re: [PATCH] mac80211: WEP extra head/tail room in ieee80211_send_auth
References: <1402419608-11892-1-git-send-email-emmanuel.grumbach@intel.com>
	<1402682460.4478.32.camel@jlt4.sipsolutions.net>
Date: Sat, 14 Jun 2014 11:00:41 +0300
In-Reply-To: <1402682460.4478.32.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Fri, 13 Jun 2014 20:01:00 +0200")
Message-ID: <87sin7zzrq.fsf@purkki.adurom.net> (sfid-20140614_100058_159325_FF281171)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2014-06-10 at 20:00 +0300, Emmanuel Grumbach wrote:
>> From: Max Stepanov <Max.Stepanov@intel.com>
>> 
>> After skb allocation and call to ieee80211_wep_encrypt in ieee80211_send_auth
>> the flow fails with a warning in ieee80211_wep_add_iv on verification of
>> available head/tailroom needed for WEP_IV and WEP_ICV.
>
> Applied. There's still time - should that be Cc stable?

Is this a regression?

-- 
Kalle Valo
