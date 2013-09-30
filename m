Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f41.google.com ([209.85.216.41]:48659 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab3I3SKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 14:10:42 -0400
Received: by mail-qa0-f41.google.com with SMTP id ii20so2587651qab.0
        for <linux-wireless@vger.kernel.org>; Mon, 30 Sep 2013 11:10:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52492FB0.3010201@einfach.org>
References: <52492FB0.3010201@einfach.org>
From: Weedy <weedy2887@gmail.com>
Date: Mon, 30 Sep 2013 14:10:22 -0400
Message-ID: <CAFE24U2wxz-NrGpTtLEemmCkkLf=xWbMc_rchjMSB3PKdTOKjQ@mail.gmail.com> (sfid-20130930_201045_857886_0B588D7B)
Subject: Re: ath9k AR9287 status?
To: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 30, 2013 at 4:00 AM, Bruno Randolf <br1@einfach.org> wrote:
> Or - can anyone recommend a good half size PCI-Express card that works well
> with ath9k?

http://www.ebay.com/itm/450M-Apple-AirPort-Extreme-Atheros-AR5BXB112-AR9380-N-card-NOT-AR5BXB92-AR5BXB72-/110965122470?ssPageName=ADME:L:OC:CA:3160
This is the current macbook pro card. Atheros talks about a half
length version without the high power amps but I don't know the part
number. And my laptop takes full sized cards :D

http://www.ebay.ca/sch/i.html?_sacat=0&_from=R40&_nkw=Atheros+half+AR5B22&_sop=15
This is the ARM based chromebook card. It includes bluetooth.

I own both cards and they work fine in linux and windows7. Atheros
bluetooth w7 drivers are a bitch.
I run gentoo so my kernel is hand rolled, maybe something in your
distro kernel is breaking stuff?
