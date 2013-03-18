Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:46945 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3CRIiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 04:38:02 -0400
Received: by mail-da0-f47.google.com with SMTP id s35so1205303dak.20
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2013 01:38:01 -0700 (PDT)
Date: Mon, 18 Mar 2013 01:37:52 -0700
From: Jonathan Nieder <jrnieder@gmail.com>
To: =?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
Cc: 664767@bugs.debian.org, Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Brcmsmac driver woes, possible regression?
Message-ID: <20130318083752.GA6570@elie.Belkin> (sfid-20130318_093808_109214_B44DDFF7)
References: <20130317144603.GA4850@stt008.linux.site>
 <1363532310.3937.266.camel@deadeye.wl.decadent.org.uk>
 <20130317152428.GA4940@stt008.linux.site>
 <20130317175658.GA8181@elie.Belkin>
 <20130317182725.GA5811@stt008.linux.site>
 <20130317183344.GA8786@elie.Belkin>
 <CAKprTDFhNnGOPHUqg8Wn6Cd170KaeXj7-w-D6wS2Cc38vstt5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAKprTDFhNnGOPHUqg8Wn6Cd170KaeXj7-w-D6wS2Cc38vstt5A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camaleón wrote[1]:

> vermagic:       3.9.0-rc2 SMP mod_unload modversions 686
>
> As soon as I load the brcmsmac module, N-M pop-ups and asks for the
> secrets... constantly until it quits, that is, I cannot even connect
> to the wifi AP with the Broadcom card, it's a bit frustrating :-(
>
> (attaching full dmesg and syslog files)

Thanks.

> I also downloaded Debian experimental kernel sources (3.8.2), do you
> want me to compile and test this?

I see no reason to do that.

Hm.
Jonathan

[1] http://bugs.debian.org/664767
