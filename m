Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57037 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab3CRVOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 17:14:34 -0400
Received: by mail-wi0-f172.google.com with SMTP id ez12so3206389wid.5
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2013 14:14:33 -0700 (PDT)
Date: Mon, 18 Mar 2013 22:14:28 +0100
From: =?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, 664767@bugs.debian.org,
	linux-wireless@vger.kernel.org
Subject: Re: Brcmsmac driver woes, possible regression?
Message-ID: <20130318211428.GA9136@stt008.linux.site> (sfid-20130318_221444_639513_E0A093BE)
References: <20130317144603.GA4850@stt008.linux.site> <1363532310.3937.266.camel@deadeye.wl.decadent.org.uk> <20130317152428.GA4940@stt008.linux.site> <20130317175658.GA8181@elie.Belkin> <20130317182725.GA5811@stt008.linux.site> <20130317183344.GA8786@elie.Belkin> <CAKprTDFhNnGOPHUqg8Wn6Cd170KaeXj7-w-D6wS2Cc38vstt5A@mail.gmail.com> <20130318083752.GA6570@elie.Belkin> <51476D25.6030609@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <51476D25.6030609@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El 2013-03-18 a las 20:38 +0100, Arend van Spriel escribió:

> On 03/18/2013 09:37 AM, Jonathan Nieder wrote:
>> Camaleón wrote[1]:
>>
>>> vermagic:       3.9.0-rc2 SMP mod_unload modversions 686
>>>
>>> As soon as I load the brcmsmac module, N-M pop-ups and asks for the
>>> secrets... constantly until it quits, that is, I cannot even connect
>>> to the wifi AP with the Broadcom card, it's a bit frustrating :-(
>
> Sorry to hear. Reading back the bug report I noticed you are having a  
> bcm4313 and we recently had a regression on it. Could you provide  
> debugfs information from <debugfs_mount>/brcmsmac/bcma0:0/hardware

I see. My "/sys/kernel/debug/*" directory is empty so now that I'm going 
to recompile the whole kernel again to revert the patch, is there any 
flag I need to turn on at the ".config" file to enable the debug for 
brcmsmac or any additional flag it could be interesting for this?

> The regression was caused by following commit:
>
> "brcmsmac: support 4313iPA" b6fc28a158076ca2764edc9a6d1e1402f56e1c0c
>
> If possible you can revert that and see how that goes.

It will cost me a bunch of dislikes ;-) but sure, I'll try and report 
back.

Greetings,

-- 
Camaleón 
