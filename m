Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:29068 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbZGUTwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 15:52:07 -0400
Message-ID: <4A661C4B.5070803@nokia.com>
Date: Tue, 21 Jul 2009 22:51:39 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: ext Kalle Valo <kalle.valo@iki.fi>
CC: Joe Perches <joe@perches.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"jirislaby@gmail.com" <jirislaby@gmail.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: add wl1251 wireless driver
References: <20090721191136.22374.69017.stgit@tikku>	<20090721191154.22374.17349.stgit@tikku>	<1248204540.31365.275.camel@Joe-Laptop.home> <87ocrdsu9f.fsf@litku.valot.fi>
In-Reply-To: <87ocrdsu9f.fsf@litku.valot.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Kalle Valo wrote:
> Joe Perches <joe@perches.com> writes:
>
>   
>>> +F:	drivers/net/wireless/wl12xx/wl1251*
>>>       
>> Not that I'm asking you to maintain more than you want to,
>> but why not:
>>
>> F:	drivers/net/wireless/wl12xx/
>>     
>
> Just because Luciano will soon publish wl1271 driver (which will use
> wl1271_ prefix) and he will be maintaining that part, no other reason.
>
> But what should we do with the shared Makefile and Kconfig? Also in the
> future we might share some of the code between 1251 and 1271. Any tips
> for this?
>   

I think we have to choose one maintainer for the shared files (= you! 
;).  So we could have something like this for your part:

F:   drivers/net/wireless/wl12xx/*
X:   drivers/net/wireless/wl12xx/wl1271*

Of course this doesn't apply yet, because there is no wl1271* at the 
moment (hopefully there will be very soon).  So, for now I think you 
could have just the F line.  And when I add my maintainer's block there, 
I can add the X line to your part at the same time... How does that sound?

-- 
Cheers,
Luca.

