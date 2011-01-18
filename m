Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa01-08.prod.phx3.secureserver.net ([72.167.82.88]:46069
	"HELO p3plsmtpa01-08.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752562Ab1ARPV5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 10:21:57 -0500
Message-ID: <48A27D1459A9493C8A16D0D6308A5FB1@ChuckPC>
From: "Chuck Crisler" <ccrisler@vgocom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
References: <D323CFEF4DEC4E18AFF56742F78C16B6@ChuckPC> <1295347932.3563.13.camel@jlt3.sipsolutions.net> <BB274B92115347F9A8E250DEF0C2B732@ChuckPC> <1F9D19D1999A4D7885D0A4DD7BEBCEE8@ChuckPC> <1295362622.3563.23.camel@jlt3.sipsolutions.net>
In-Reply-To: <1295362622.3563.23.camel@jlt3.sipsolutions.net>
Subject: Re: intermittent eap authentication failure
Date: Tue, 18 Jan 2011 10:21:48 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What is the reason that the design calls for a scan in response to a session 
timeout? A session timeout doesn't happen because of a roam, so the original 
AP is probably still good. Why scan?

Chuck

----- Original Message ----- 
From: "Johannes Berg" <johannes@sipsolutions.net>
To: "Chuck Crisler" <ccrisler@vgocom.com>
Cc: <linux-wireless@vger.kernel.org>
Sent: Tuesday, January 18, 2011 9:57 AM
Subject: Re: intermittent eap authentication failure


> On Tue, 2011-01-18 at 09:54 -0500, Chuck Crisler wrote:
>> I will have to reply later about why it is associating. I will have to 
>> add a
>> printk to my driver but I currently have 2 tests running and don't want 
>> to
>> stop either.
>> It looks like it might be called by ieee80211_sta_work() in mlme.c 
>> because
>> it might still be in the IEEE80211_STA_MLME_ASSOCIATE state. I will 
>> confirm
>> that.
>
> Did you ever consider using compat-wireless? Frankly, my main memory
> isn't large enough to hold information about old mac80211 behaviour so I
> have to get that information from swap (git tree) and that's really
> slow :-)
>
> johannes
>
> 

