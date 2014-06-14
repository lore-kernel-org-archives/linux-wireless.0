Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43100 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbaFNT7K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2014 15:59:10 -0400
Message-ID: <1402775942.5026.0.camel@jlt4.sipsolutions.net> (sfid-20140614_220117_799428_FFC77A22)
Subject: Re: [PATCH] mac80211: WEP extra head/tail room in
 ieee80211_send_auth
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org,
	Max Stepanov <Max.Stepanov@intel.com>
Date: Sat, 14 Jun 2014 21:59:02 +0200
In-Reply-To: <87sin7zzrq.fsf@purkki.adurom.net>
References: <1402419608-11892-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1402682460.4478.32.camel@jlt4.sipsolutions.net>
	 <87sin7zzrq.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-06-14 at 11:00 +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > On Tue, 2014-06-10 at 20:00 +0300, Emmanuel Grumbach wrote:
> >> From: Max Stepanov <Max.Stepanov@intel.com>
> >> 
> >> After skb allocation and call to ieee80211_wep_encrypt in ieee80211_send_auth
> >> the flow fails with a warning in ieee80211_wep_add_iv on verification of
> >> available head/tailroom needed for WEP_IV and WEP_ICV.
> >
> > Applied. There's still time - should that be Cc stable?
> 
> Is this a regression?

Good question. I don't think anything changed this code recently, but
maybe something changed skb allocation or so? Max?

johannes

