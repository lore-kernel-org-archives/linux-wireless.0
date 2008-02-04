Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:32201 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbYBDL0K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 06:26:10 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2895181wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 03:26:10 -0800 (PST)
Message-ID: <1ba2fa240802040326v425fe147y52f2d8731e3012cb@mail.gmail.com> (sfid-20080204_112617_095149_5409925E)
Date: Mon, 4 Feb 2008 13:26:10 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: add rate to ieee80211_tx_status
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Felix Fietkau" <nbd@openwrt.org>
In-Reply-To: <-2417195033053015320@unknownmsgid>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12020697053277-git-send-email-tomas.winkler@intel.com>
	 <1202114774.4188.127.camel@johannes.berg>
	 <1ba2fa240802040153g1d0c9902u6af2ddf3dead975d@mail.gmail.com>
	 <6231174111099834440@unknownmsgid>
	 <1ba2fa240802040227g23fe41adu446adc8f0de22712@mail.gmail.com>
	 <-6799378017406559341@unknownmsgid>
	 <1ba2fa240802040305u611bb7edk3c757b73f40c1037@mail.gmail.com>
	 <-4694429725714512287@unknownmsgid>
	 <1ba2fa240802040321s515e61deld176d79eef2b444d@mail.gmail.com>
	 <-2417195033053015320@unknownmsgid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 4, 2008 1:23 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Tomas Winkler wrote:
> > No, they are rate specific the are not modulation specific, each of
> > them can change from packet to packet.
>
> Exactly. flags in the bitrate struct aren't meant to change from packet to
> packet but be specific to a bitrate. The way I see it these are TX control
> or rate control flags, not rate flags.

I see, I got it.
Yes you are right. they should be part of the statuses.
Tomas

> johannes
>
