Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51817 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900AbZHWIG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Aug 2009 04:06:28 -0400
Received: by bwz19 with SMTP id 19so1024548bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2009 01:06:29 -0700 (PDT)
To: Rafael Laufer <rlaufer@CS.UCLA.EDU>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	=?iso-8859-15?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Implementation of the IEEE80211_RADIOTAP_RATE option
References: <4A8DED03.2050502@cs.ucla.edu>
	<1250842695.13872.5.camel@johannes.local>
	<69e28c910908210630m47eda1eegcd502c212736decd@mail.gmail.com>
	<4A8EE182.6040709@cs.ucla.edu>
	<1250927308.23605.6.camel@johannes.local>
	<4A906B4C.6010208@cs.ucla.edu>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 23 Aug 2009 11:06:26 +0300
In-Reply-To: <4A906B4C.6010208@cs.ucla.edu> (Rafael Laufer's message of "Sat\, 22 Aug 2009 15\:03\:56 -0700")
Message-ID: <87ab1rt0n1.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafael Laufer <rlaufer@CS.UCLA.EDU> writes:

>>> +		/* Get the rate parameter from the radiotap header, +
>>> * allowing rate selection on a per-packet basis +		 */
>>>     
>>
>> coding style
>>   
>
> I am a newbie, I am gonna look into the coding style, 

In case you didn't know, Documentation/CodingStyle is the file you want
to need.

> but I assume you are talking about the missing blank line in the
> beginning

I think Johannes' means the comment style:

/*
 * The prefer multiline comments to look like this. blah blah blah blah
 * blah blah blah blah blah blah blah blah blah blah blah blah
 */

-- 
Kalle Valo
