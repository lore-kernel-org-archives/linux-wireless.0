Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.getmail.no ([84.208.15.66]:40421 "EHLO
	get-mta-out02.get.basefarm.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754282Ab0AYTWK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 14:22:10 -0500
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Received: from smtp.getmail.no ([10.5.16.4]) by get-mta-out02.get.basefarm.net
 (Sun Java(tm) System Messaging Server 7.0-0.04 64bit (built Jun 20 2008))
 with ESMTP id <0KWT0069HHSVCHA0@get-mta-out02.get.basefarm.net> for
 linux-wireless@vger.kernel.org; Mon, 25 Jan 2010 20:22:07 +0100 (MET)
Received: from [192.168.1.10] ([84.208.235.192])
 by get-mta-in01.get.basefarm.net
 (Sun Java(tm) System Messaging Server 7.0-0.04 64bit (built Jun 20 2008))
 with ESMTPA id <0KWT001T1HSU3L20@get-mta-in01.get.basefarm.net> for
 linux-wireless@vger.kernel.org; Mon, 25 Jan 2010 20:22:07 +0100 (MET)
Message-id: <4B5DEF5E.8050502@bzz.no>
Date: Mon, 25 Jan 2010 20:22:06 +0100
From: "John S. Skogtvedt" <jss@bzz.no>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Bug: 2.6.32 ath5k, unable to connect to AP on channel 13
References: <4B5CB7AB.7010105@bzz.no>
 <b6c5339f1001250951u548e6a16raf661464660ec577@mail.gmail.com>
In-reply-to: <b6c5339f1001250951u548e6a16raf661464660ec577@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland skrev:
> On Sun, Jan 24, 2010 at 4:12 PM, John S. Skogtvedt <jss@bzz.no> wrote:
>> Hello,
>>
>> As the subject says, using ath5k on 2.6.32 I am not able to connect to
>> an AP on channel 13 (i.e. wpa_supplicant doesn't find the AP and thus
>> fails to associate). I'm in Norway, and the card is bought in Norway.
> 
>> dmesg output:
>> [    7.205952] cfg80211: Using static regulatory domain info
>> [    7.205956] cfg80211: Regulatory domain: US
>> [    7.206243] cfg80211: Calling CRDA for country: US
> 
> Well, there's your problem, AFAICT.  You have
> CONFIG_WIRELESS_OLD_REGULATORY=y?  And ieee80211_regdom=EU doesn't work?
> 

Yes, CONFIG_WIRELESS_OLD_REGULATORY=y. And neither ieee80211_regdom=EU
or ieee80211_regdom=NO works.
