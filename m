Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39136 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaFMSBO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 14:01:14 -0400
Message-ID: <1402682460.4478.32.camel@jlt4.sipsolutions.net> (sfid-20140613_200116_588519_5E7656AF)
Subject: Re: [PATCH] mac80211: WEP extra head/tail room in
 ieee80211_send_auth
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Max Stepanov <Max.Stepanov@intel.com>
Date: Fri, 13 Jun 2014 20:01:00 +0200
In-Reply-To: <1402419608-11892-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1402419608-11892-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-06-10 at 20:00 +0300, Emmanuel Grumbach wrote:
> From: Max Stepanov <Max.Stepanov@intel.com>
> 
> After skb allocation and call to ieee80211_wep_encrypt in ieee80211_send_auth
> the flow fails with a warning in ieee80211_wep_add_iv on verification of
> available head/tailroom needed for WEP_IV and WEP_ICV.

Applied. There's still time - should that be Cc stable?

johannes

