Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:47058 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYLSOwz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 09:52:55 -0500
Received: by ewy10 with SMTP id 10so1100587ewy.13
        for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 06:52:53 -0800 (PST)
Message-ID: <494BB53C.9050401@gmail.com> (sfid-20081219_155259_255340_3401C896)
Date: Fri, 19 Dec 2008 09:52:44 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: Re: [PATCH] [RFC] mac80211: Disable HT negotiation with TKIP/WEP
 as pairwise cipher
References: <1229692235-21734-1-git-send-email-vasanth@atheros.com> <20081219142822.GA4041@tuxdriver.com> <494BB0BE.3030705@atheros.com> <20081219144256.GB4041@tuxdriver.com>
In-Reply-To: <20081219144256.GB4041@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Fri, Dec 19, 2008 at 08:03:34PM +0530, Vasanthakumar Thiagarajan wrote:
>   
>> John W. Linville wrote:
>>     
>>> On Fri, Dec 19, 2008 at 06:40:35PM +0530, Vasanthakumar Thiagarajan wrote:
>>>       
>>>> IEEE802.11n does not allow TKIP/WEP as pairwise cipher in HT mode.
>>>> Connect in non-ht mode if either of these ciphers is cofigured as
>>>> pairwise.
>>>>
>>>> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
>>>>         
>>> Are there perhaps any broken APs out there that support such a
>>> configuration?  I would hate to prevent users from connecting simply
>>> out of blind obedience to the standard.
>>>       
>> This particular configuration is not allowed in the latest 11n draft (7.0).
>> Yes, we have quite a few AP's around which support this configuration. 
>>     
>
> Honestly, as a STA I would rather violate the standard and connect
> to the coffee shop's broken/misconfigured pre-draft7 .11n AP than stand
> on principle and have to fall back on my cell phone's data plan or sip
> my latte in internet silence... :-)
>
>   
ACKED-BY: Rick Farina

I think as a station we should support connecting to the AP unless it is 
against the law.  If you want to stand on principle in master or IBSS 
then that is fair, but please give the stations a bit more wiggle room.

thanks,
Rick Farina
> John
>   

