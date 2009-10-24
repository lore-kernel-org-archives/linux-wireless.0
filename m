Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:58812 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZJXX1F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2009 19:27:05 -0400
Received: by ewy4 with SMTP id 4so2649298ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2009 16:27:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1256052469.6550.7.camel@kpucynski-laptop>
References: <1256052469.6550.7.camel@kpucynski-laptop>
Date: Sun, 25 Oct 2009 02:27:08 +0300
Message-ID: <40f31dec0910241627i5dec6d33g57af6a1104bce91c@mail.gmail.com>
Subject: Re: Wrong BSSID generation in IBSS mode with ath5k
From: Nick Kossifidis <mickflemm@gmail.com>
To: =?UTF-8?Q?Karol_Pucy=C5=84ski?= <kpucynski@7bulls.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/10/20 Karol Pucyński <kpucynski@7bulls.com>:
> Hi
>
> I have IBSS network (based on ath5k cards).
> With the same channel/essid set cards often can't "negotiate" the
> same BSSID. Two nodes beside each other both create new IBSS networks
> and they are not trying to merge.
> Workaround: forcing BSSID with iw does work.
>
> Do you know what can be the reason of this problem?
>
> Tested on 2.6.31 kernel. May be related to my earlier problem 'ath5k
> IBSS fixed rate'...
>
> Best regards
> --
> Karol Pucyński
> 7bulls.com Sp. z o.o.
> kpucynski@7bulls.com
>

In my tests i had to force a scan on one of the cards (so that it
knows what cells are active) and then set the essid. Does that work
for you ?

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
