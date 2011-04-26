Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from treacle.ucs.ed.ac.uk ([129.215.16.102]:44238 "EHLO
	treacle.ucs.ed.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab1DZMfG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 08:35:06 -0400
Message-ID: <20110426125801.q89ma5n6cgkwog80@www.sms.ed.ac.uk> (sfid-20110426_143510_754584_C1FC83BE)
Date: Tue, 26 Apr 2011 12:58:01 +0100
From: Lito Kriara <L.Kriara@sms.ed.ac.uk>
To: Mohammed Shafi <mshajakhan@Atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Add num_stations connected in debugfs
References: <1303646133-2809-1-git-send-email-mshajakhan@atheros.com>
	<1303652185.3603.0.camel@jlt3.sipsolutions.net>
	<4DB4318F.6070801@atheros.com>
	<1303657150.3603.1.camel@jlt3.sipsolutions.net>
	<4DB4415F.2070707@atheros.com>
	<1303659120.3603.3.camel@jlt3.sipsolutions.net>
	<4DB4F8D5.1060108@atheros.com>
In-Reply-To: <4DB4F8D5.1060108@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I was away the last couple of days and just saw these e-mails. It  
seems really interesting and helpful, but what if we need to know at  
runtime the number of stations connected to the AP?
Is the first patch sent good to use? Should I do some modification to it?

Thank you all very much,
Lito


Quoting Mohammed Shafi <mshajakhan@Atheros.com> on Mon, 25 Apr 2011  
10:00:13 +0530:

> On Sunday 24 April 2011 09:02 PM, Johannes Berg wrote:
>> On Sun, 2011-04-24 at 20:57 +0530, Mohammed Shafi wrote:
>>
>>> On Sunday 24 April 2011 08:29 PM, Johannes Berg wrote:
>>>
>>>> iw wlan0 station dump | grep ... | wc -l
>>>>
>>> thanks, that  works! I need to divide by 11 :)
>>>
>> Heh, yes, but that might change and/or be HW dependent, hence grep. So
>> if you do
>>
>> iw wlan0 station dump | grep '^Station ' | wc -l
>>
>> you won't need to divide and won't be HW dependent.
>>
> Oh ok, thanks!
> regards,
> shafi
>
>> johannes
>>
>>



-- 
The University of Edinburgh is a charitable body, registered in
Scotland, with registration number SC005336.


