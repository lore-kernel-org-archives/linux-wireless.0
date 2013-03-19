Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f181.google.com ([209.85.210.181]:35979 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947Ab3CSJnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 05:43:43 -0400
Received: by mail-ia0-f181.google.com with SMTP id o25so217570iad.40
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 02:43:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130318212544.GB5062@elie.Belkin>
References: <20130317144603.GA4850@stt008.linux.site>
	<1363532310.3937.266.camel@deadeye.wl.decadent.org.uk>
	<20130317152428.GA4940@stt008.linux.site>
	<20130317175658.GA8181@elie.Belkin>
	<20130317182725.GA5811@stt008.linux.site>
	<20130317183344.GA8786@elie.Belkin>
	<CAKprTDFhNnGOPHUqg8Wn6Cd170KaeXj7-w-D6wS2Cc38vstt5A@mail.gmail.com>
	<20130318083752.GA6570@elie.Belkin>
	<51476D25.6030609@broadcom.com>
	<20130318211428.GA9136@stt008.linux.site>
	<20130318212544.GB5062@elie.Belkin>
Date: Tue, 19 Mar 2013 10:43:42 +0100
Message-ID: <CAKprTDFXV4J7cxGqNck95Cu=ncBXCfdNTir40aWRtXjpLPO6OQ@mail.gmail.com> (sfid-20130319_104351_672893_170051DA)
Subject: Re: Brcmsmac driver woes, possible regression?
From: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>, 664767@bugs.debian.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/18 Jonathan Nieder <jrnieder@gmail.com>:
> Camaleón wrote:
>> El 2013-03-18 a las 20:38 +0100, Arend van Spriel escribió:
>
>>> Sorry to hear. Reading back the bug report I noticed you are having a
>>> bcm4313 and we recently had a regression on it. Could you provide
>>> debugfs information from <debugfs_mount>/brcmsmac/bcma0:0/hardware
>>
>> I see. My "/sys/kernel/debug/*" directory is empty
>
> mount -t debugfs debugfs /sys/kernel/debug

Perfect, thanks.

root@stt300:~# cat /sys/kernel/debug/brcmsmac/bcma0\:0/hardware
board vendor: 103c
board type: 145c
board revision: 2209
board flags: 8002a00
board flags2: 800
firmware revision: 262032b

Now let's see how reverting the patch makes any difference as soon as
I can compile the module. I will keep you updated

Greetings,

-- 
Camaleón
