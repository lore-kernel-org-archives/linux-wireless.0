Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48149 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbbFKNQa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 09:16:30 -0400
Message-ID: <55798A2C.7070300@candelatech.com> (sfid-20150611_151633_395926_3E3E6773)
Date: Thu, 11 Jun 2015 06:16:28 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	=?UTF-8?B?UmFmYcWCIE1pxYJl?= =?UTF-8?B?Y2tp?= <zajec5@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Exposing enum ieee80211_channel_flags to user
References: <CACna6rwHXzGTZ+NS9PpZENJATVzRzm1Wkija0_CrveMoM05d5g@mail.gmail.com>	 <1434015922.1915.6.camel@sipsolutions.net>	 <1434016002.1915.7.camel@sipsolutions.net>	 <CACna6ry_VRbUbEQeVXC5j68VzPOkJ-qOsAGzKN8XswhHXnO+tw@mail.gmail.com>	 (sfid-20150611_120017_614164_3F327AEA) <1434016900.1915.8.camel@sipsolutions.net>
In-Reply-To: <1434016900.1915.8.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/11/2015 03:01 AM, Johannes Berg wrote:
> On Thu, 2015-06-11 at 12:00 +0200, Rafał Miłecki wrote:
>
>>> Upon rereading, I think my preference would be to remove much of the
>>> channel list information and add a separate iw command.
>>
>> Do you mean removing channel list from "iw phy X info"?
>
> I'm not sure I'd remove it completely - but perhaps remove all the
> detail information like DFS time etc. that's just making it really
> large? I.e. go back to just having a single line of information.
>
>> Can you suggest the new command name?
>
> "iw phy X channels" would work?

Maybe also allow the full dump with an optional --verbose flag:  'iw --verbose phy X info' ?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
