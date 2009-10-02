Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:53192 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbZJBLsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 07:48:36 -0400
Received: by ewy7 with SMTP id 7so1013807ewy.17
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2009 04:48:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910020910.47068.hs4233@mail.mn-solutions.de>
References: <2d0a357f0910010247jfda1199h5a9b873233b186ca@mail.gmail.com>
	 <1254426421.3959.29.camel@johannes.local>
	 <2d0a357f0910011344u4306ecf6ha11410b0f5ed62e3@mail.gmail.com>
	 <200910020910.47068.hs4233@mail.mn-solutions.de>
Date: Fri, 2 Oct 2009 13:48:39 +0200
Message-ID: <2d0a357f0910020448q8747e3as222fa5826852a5b3@mail.gmail.com>
Subject: Re: Linux-2.6.32-rc1/2] wext refactor needs wpasupplicant 0.7.0+?
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The logs were not helpful (running wpa_supplicant in background), I
send new ones to Johannes via PM directly.
I was not sure if the logs had sensitive informations.
The problem was discussed on IRC and the problem with v0.6.9 does not
exist anymore.

- Sedat -

On Fri, Oct 2, 2009 at 9:10 AM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
> In both logs you have
>
> 1254429476.088527: ctrl_iface bind(PF_UNIX) failed: Address already in use
> 1254429476.088543: ctrl_iface exists and seems to be in use - cannot override it
> 1254429476.088548: Delete '/var/run/wpa_supplicant/wlan0' manually if it is not used anymore
>
> are you sure that no other wpa_supplicant did
> run when you made the logs?
>
> If yes, then just remove the file and re-run wpa_supplicant.
> Be sure to run it as "root".
>
> --
> http://www.holgerschurig.de
>
