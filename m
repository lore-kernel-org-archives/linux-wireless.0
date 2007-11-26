Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:48796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbXKZQ56 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 11:57:58 -0500
From: Andreas Schwab <schwab@suse.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	tomas.winkler@intel.com
Subject: Re: [PATCH 04/15] mac80211: adding 802.11n IEs handling
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
	<1196086490284-git-send-email-ron.rindjunsky@intel.com>
	<1196094586.4149.297.camel@johannes.berg>
Date: Mon, 26 Nov 2007 17:57:55 +0100
In-Reply-To: <1196094586.4149.297.camel@johannes.berg> (Johannes Berg's
	message of "Mon\, 26 Nov 2007 17\:29\:46 +0100")
Message-ID: <jefxyteygc.fsf@sykes.suse.de> (sfid-20071126_165803_573384_6EA2E86A)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2007-11-26 at 16:14 +0200, Ron Rindjunsky wrote:
>> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
>> index 9e5b3a9..9caf124 100644
>> --- a/net/mac80211/ieee80211_i.h
>> +++ b/net/mac80211/ieee80211_i.h
>> @@ -89,6 +89,8 @@ struct ieee80211_sta_bss {
>>  	size_t rsn_ie_len;
>>  	u8 *wmm_ie;
>>  	size_t wmm_ie_len;
>> +	u8 *ht_ie;
>> +	size_t ht_ie_len;
>
> At some point we probably should reorder the fields here to avoid all
> the padding... Not in this patch though, of course.

There should not be any padding, size_t has the same size as a pointer.

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4=
ED5
"And now for something completely different."
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
