Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:57285 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZGXJUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 05:20:03 -0400
Received: by bwz28 with SMTP id 28so1311376bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2009 02:20:02 -0700 (PDT)
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: Joe Perches <joe@perches.com>,
	"linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"jirislaby\@gmail.com" <jirislaby@gmail.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: add wl1251 wireless driver
References: <20090721191136.22374.69017.stgit@tikku>
	<20090721191154.22374.17349.stgit@tikku>
	<1248204540.31365.275.camel@Joe-Laptop.home>
	<87ocrdsu9f.fsf@litku.valot.fi> <4A661C4B.5070803@nokia.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 24 Jul 2009 12:19:58 +0300
In-Reply-To: <4A661C4B.5070803@nokia.com> (Luciano Coelho's message of "Tue\, 21 Jul 2009 22\:51\:39 +0300")
Message-ID: <878wiesaip.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <luciano.coelho@nokia.com> writes:

> I think we have to choose one maintainer for the shared files (= you!
> ;).  So we could have something like this for your part:
>
> F:   drivers/net/wireless/wl12xx/*
> X:   drivers/net/wireless/wl12xx/wl1271*
>
> Of course this doesn't apply yet, because there is no wl1271* at the
> moment (hopefully there will be very soon).  So, for now I think you
> could have just the F line.  And when I add my maintainer's block
> there, I can add the X line to your part at the same time... How does
> that sound?

Sounds good to me. I'm too lazy to send a new patch right now, but can
you change the entry accordingly when you submit 1271 code?

-- 
Kalle Valo
