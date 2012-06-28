Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3853 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab2F1MyL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 08:54:11 -0400
Message-ID: <4FEC53DE.70602@broadcom.com> (sfid-20120628_145415_109104_F52FAA47)
Date: Thu, 28 Jun 2012 14:53:50 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Mahesh Palivela" <maheshp@posedge.com>
cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211/mac80211: 802.11ac changes
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0B3E4E@mbx022-e1-nj-10.exch022.domain.local>,<1340881646.4491.41.camel@jlt3.sipsolutions.net>
 <952C5D5D0470AE4FB7D8A75C6ADC71CA0D612F@mbx022-e1-nj-10.exch022.domain.local>
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0D612F@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/28/2012 02:39 PM, Mahesh Palivela wrote:
> ________________________________________
> From: Johannes Berg [johannes@sipsolutions.net]
> Sent: Thursday, June 28, 2012 4:37 PM
> To: Mahesh Palivela
> Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org
> Subject: Re: [PATCH] cfg80211/mac80211: 802.11ac changes
> 
>>
>> +     if (sband->vht_cap.vht_supported)
>> +             pos = ieee80211_ie_build_vht_cap(pos, &sband->vht_cap,
>> +                                             sband->vht_cap.cap);
> 
> indentation
> 
> [MP] sorry. I didn't get. Is it sband-> line to be moved left? But previous build_ht_cap() has similar indentation
> 

'sband->' should start at same column as 'pos' in the above line. Must
be tabs followed by right amount of spaces (being less than 8).

>>       return pos - buffer;
>>  }
>>
>> @@ -1696,6 +1700,27 @@ u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
>>       return pos;
>>  }
>>
>> +u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
>> +                           u32 cap)
> 
> indentation here & in ieee80211_i.h
> 
> [MP] ditto. please explain
> 

'u32' should start at same column as 'u8 *pos' in the above line.

Gr. AvS


