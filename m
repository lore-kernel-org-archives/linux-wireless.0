Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:43827 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab2LTLzz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 06:55:55 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 20 Dec 2012 03:55:54 -0800
From: vivekanandah@posedge.com
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: Re: adding =?UTF-8?Q?ba=5Fpolicy=20member=20in=20drv=5Fampdu?=
 =?UTF-8?Q?=5Faction=20op=20-=20request=20information?=
In-Reply-To: <1356003605.10029.9.camel@jlt4.sipsolutions.net>
References: <53a9b58ee917248d8fa617dd1bbcde83@posedge.com>
 <1355407319.9463.4.camel@jlt4.sipsolutions.net>
 <ccd9b999d335370ce1508dae369e0951@posedge.com>
 <1356003605.10029.9.camel@jlt4.sipsolutions.net>
Message-ID: <ee2c366af04f45dceda3d3b6d1d130c1@posedge.com> (sfid-20121220_125600_470915_02717304)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi johannes,

i agree on that count :)

thanks and regards
Vivek





On Thu, 20 Dec 2012 12:40:05 +0100, Johannes Berg wrote:
> On Thu, 2012-12-20 at 02:39 -0800, vivekanandah@posedge.com wrote:
>
>> is'nt the station's capability and the AP capability intersected 
>> during
>> association? i always thought that the comment was mis-represented.
>>
>> i did a small test and i see that the stations capability is 
>> actually
>> the subset of AP capabilities that both support.
>> if that is the case, then we do not have to check for the capability
>> independently there! do i miss something in my understanding?
>>
>> also, if what i have stated above is correct, then yes, i feel 
>> delayed
>> block ack as a feature might need to be implemented on mac80211 and 
>> then
>> check for the same.
>
> I don't see what difference that makes? You still have to implement 
> the
> feature fully, we don't have support for it at all.
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

