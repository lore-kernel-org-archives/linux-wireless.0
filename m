Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38041 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079Ab1DXOUG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 10:20:06 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 24 Apr 2011 07:19:39 -0700
Message-ID: <4DB4318F.6070801@atheros.com> (sfid-20110424_162010_599022_2FF1D186)
Date: Sun, 24 Apr 2011 19:49:59 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"L.Kriara@sms.ed.ac.uk" <L.Kriara@sms.ed.ac.uk>
Subject: Re: [PATCH] mac80211: Add num_stations connected in debugfs
References: <1303646133-2809-1-git-send-email-mshajakhan@atheros.com> <1303652185.3603.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1303652185.3603.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 24 April 2011 07:06 PM, Johannes Berg wrote:
> On Sun, 2011-04-24 at 17:25 +0530, Mohammed Shafi Shajakhan wrote:
>    
>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>
>> this will be useful when the device is operating in AP/Ad-Hoc/Mesh
>> mode
>>      
> Fine with me, but this counts for all virtual interfaces.
>    
thanks, I  had not thought about that. let me also if we can separately 
have the number of stations connected to each virtual interfaces.
> johannes
>
>
>    
