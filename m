Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37325 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab0IFKxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Sep 2010 06:53:55 -0400
Received: by qyk36 with SMTP id 36so2246134qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Sep 2010 03:53:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimVRPTRdMe-pEusXxCiZXjPPWSFfXY7CRiyRazj@mail.gmail.com>
References: <AANLkTim_Ou8fFbfsn8AEZFpWBzjnAQuT4S_w8bV5saYD@mail.gmail.com>
	<loom.20100903T224155-155@post.gmane.org>
	<AANLkTikdXBsO0Qx2nEV+Ka9X2D55odmGwePMaUGaQi7j@mail.gmail.com>
	<AANLkTinu_4tsfJ=0CXS7yuuiqw0X5juqjP_T_edw0b4Y@mail.gmail.com>
	<AANLkTi=aJssChg0uiEec-Pa=3oOdc3cFoee1X7U7BWwF@mail.gmail.com>
	<AANLkTimVRPTRdMe-pEusXxCiZXjPPWSFfXY7CRiyRazj@mail.gmail.com>
Date: Mon, 6 Sep 2010 12:53:53 +0200
Message-ID: <AANLkTikeZT7fW1+dZM+f0z5Xnr8W4BVNupNJ5hYVTXFe@mail.gmail.com>
Subject: Re: mac80211-based commercial router?
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>,
	Bob Copeland <me@bobcopeland.com>, jpo <pommnitz@yahoo.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -Ralink: Again, platform kits contain non-mac80211 drivers, even for
> recent chipsets (at least they are open-source, though). Someone
> should find a way to make them base drivers for the eventual RT4xxx
> (?) chipsets on the rt2x00 framework.

This has been asked to Ralink, and they have promised they will do so,
currently their open source code for RT2800 also contains references
to mac80211, but this seems to be a hook into cfg80211 only.

So for now, all we have is the promise from Ralink that future Ralink
drivers will be mac80211/rt2x00 based. Obviously I will have to see
some proof before I really believe it. ;)

Ivo
