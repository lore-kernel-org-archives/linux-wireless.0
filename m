Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:32868 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbYA1Jsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 04:48:51 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2882622wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2008 01:48:51 -0800 (PST)
Message-ID: <1ba2fa240801280148r27fac26ep5403bc8ccfc6d37a@mail.gmail.com> (sfid-20080128_094856_085401_17D0CAF2)
Date: Mon, 28 Jan 2008 11:48:51 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: stefano.brivio@polimi.it
Subject: Re: mac80211 crash in ieee80211_sta_scan_work
Cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080128103739.oi3iwmmzlwo8w4gw@webmail.polimi.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <479D9B5F.5000304@lwfinger.net>
	 <1ba2fa240801280129g5c9c7b73pdfdb2eb80944ce32@mail.gmail.com>
	 <20080128103739.oi3iwmmzlwo8w4gw@webmail.polimi.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 28, 2008 11:37 AM,  <stefano.brivio@polimi.it> wrote:
> Quoting Tomas Winkler <tomasw@gmail.com>:
>
> > There are too many issues with API change patch. I think it is a good
> > direction but it's really unstable I think we need to give another
> > round before it can be applied.
>
> That has already been applied. I suggest that you point out the
> iwl4965 bugs you generically reported so that they can be fixed as well.
>
We've seen already patches to be un-applied, reverted.
I'll fix the bugs that's not problem but it takes time. I'm just
worried about the other users that find driver unusable.

Thanks
Tomas

> --
> Ciao
> Stefano
>
>
>
>
