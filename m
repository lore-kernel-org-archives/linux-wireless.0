Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:49908 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932Ab3JNRRb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 13:17:31 -0400
Received: by mail-ob0-f178.google.com with SMTP id uz6so4963400obc.37
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 10:17:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1381760529.13092.17.camel@jlt4.sipsolutions.net>
References: <1381516190-23918-1-git-send-email-yeohchunyeow@cozybit.com>
	<1381516190-23918-6-git-send-email-yeohchunyeow@cozybit.com>
	<1381760529.13092.17.camel@jlt4.sipsolutions.net>
Date: Tue, 15 Oct 2013 01:17:30 +0800
Message-ID: <CAHS2MGOuq3zaZeAE8rtpS+W9QLVHkhY_w8YrZtNFCX70ycCrxg@mail.gmail.com> (sfid-20131014_191734_426709_3349A00C)
Subject: Re: [PATCH v4 5/6] {nl,cfg,mac}80211: finalizing mesh channel switching
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org,
	"distro11s@cozybit.com" <distro11s@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> subject should read "finalize" or something I guess? Though it really
> isn't clear to me why you split up the patches as is and didn't just put
> 3/5 together as "implement mesh channel switch userspace API" or so?
I split the patches because I would like the CSA to work without even
the beacon involvement, only CSA action frame. But I will take a look
on this again.

> I don't think this belongs here, it's certainly not needed for the API.
> Maybe you need a wrapper struct or so?
Alright, will do so.

----
Chun-Yeow
