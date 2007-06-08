Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:40212 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964949AbXFHDtR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 23:49:17 -0400
Message-ID: <4668D1BB.40705@lwfinger.net>
Date: Thu, 07 Jun 2007 22:49:15 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] mac80211: Set low initial rate in rc80211_simple
References: <4668c71b.E0vXnFMnxxm8I5gE%Larry.Finger@lwfinger.net> <200706072038.36708.flamingice@sourmilk.net>
In-Reply-To: <200706072038.36708.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Thursday 07 June 2007 20:03, Larry Finger wrote:
>>  	for (i = 0; i < mode->num_rates; i++) {
>>  		if ((sta->supp_rates & BIT(i)) &&
>>  		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED))
>>  			sta->txrate = i;
>> +			break;
>>  	}
> Uh, what's the point of having a loop if you're gonna do that? ;)

Does mode->rates[0].flags automatically have IEEE80211_RATE_SUPPORTED set? That wasn't clear to me.

Larry


