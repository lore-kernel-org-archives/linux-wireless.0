Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47452 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055Ab2AZQEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 11:04:10 -0500
Received: by obcva7 with SMTP id va7so678204obc.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 08:04:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F20663C.3030500@broadcom.com>
References: <CAD2CPUEu2ha6TeYrQ4WUdXU0-hdSAAJZR5PGWagSguE1DtBSfQ@mail.gmail.com>
	<4F20663C.3030500@broadcom.com>
Date: Thu, 26 Jan 2012 17:04:09 +0100
Message-ID: <CAD2CPUH6s=UuWy0S--SjmA0WZHARVQ70qmBjh9XW9s+f2ZkoLg@mail.gmail.com> (sfid-20120126_170424_066708_28D4B16E)
Subject: Re: [bcm4329] brcmfmac on kernel 2.6.35 (Andorid)
From: Renzo Navas <renzoefra@gmail.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good Afternoon,

First, Franky thanks for the response it was very helpful to know what
to expect and re-plan my project.

As regards the hardware: basically I don't have many other choices,
the University gave me a Nexus S to develop. I think I can have access
to a Samsung Galaxy S, Galaxy S II and an HTC Dream HD, I have to find
out if some of them has a wifi card which uses a softmac driver. The
idea is going to the wild (to the city which has high density of open
wifi APs) to test the algorithm -so I need some portable device-. I
yet have to find out how much can I accomplish with the bcm4329.


> For ICS we switch to a newer driver bcmdhd which use cfg80211 instead of
> wext. If you want to use cfg80211 instead of wext, this should be a better
> choice.

I'm interested on this "bcmdhd" driver which uses cfg80211,
I have one request: is there an official source with the code of bcmdhd?


Thanks for your attention again, and have a good day

Renzo
