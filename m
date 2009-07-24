Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:36477 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbZGXKqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 06:46:11 -0400
Message-ID: <4A6990C1.3020206@nokia.com>
Date: Fri, 24 Jul 2009 13:45:21 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: ext Kalle Valo <kalle.valo@iki.fi>
CC: Joe Perches <joe@perches.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"jirislaby@gmail.com" <jirislaby@gmail.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: add wl1251 wireless driver
References: <20090721191136.22374.69017.stgit@tikku>	<20090721191154.22374.17349.stgit@tikku>	<1248204540.31365.275.camel@Joe-Laptop.home>	<87ocrdsu9f.fsf@litku.valot.fi> <4A661C4B.5070803@nokia.com> <878wiesaip.fsf@litku.valot.fi>
In-Reply-To: <878wiesaip.fsf@litku.valot.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Kalle Valo wrote:
> Luciano Coelho <luciano.coelho@nokia.com> writes:
>
>   
>> I think we have to choose one maintainer for the shared files (= you!
>> ;).  So we could have something like this for your part:
>>
>> F:   drivers/net/wireless/wl12xx/*
>> X:   drivers/net/wireless/wl12xx/wl1271*
>>
>> Of course this doesn't apply yet, because there is no wl1271* at the
>> moment (hopefully there will be very soon).  So, for now I think you
>> could have just the F line.  And when I add my maintainer's block
>> there, I can add the X line to your part at the same time... How does
>> that sound?
>>     
>
> Sounds good to me. I'm too lazy to send a new patch right now, but can
> you change the entry accordingly when you submit 1271 code?
>   

Yeps, I can do that.  I'm soooo close to getting the wl1271 driver to 
work... (famous last words ;)

-- 
Cheers,
Luca.

