Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:57886 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYBDL5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 06:57:47 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2908293wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 03:57:47 -0800 (PST)
Message-ID: <1ba2fa240802040357vf517e6as374540e28dd1ab56@mail.gmail.com> (sfid-20080204_115751_248522_0053A2FD)
Date: Mon, 4 Feb 2008 13:57:46 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: add rate to ieee80211_tx_status
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Felix Fietkau" <nbd@openwrt.org>
In-Reply-To: <5358276387473684738@unknownmsgid>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12020697053277-git-send-email-tomas.winkler@intel.com>
	 <1ba2fa240802040227g23fe41adu446adc8f0de22712@mail.gmail.com>
	 <-6799378017406559341@unknownmsgid>
	 <1ba2fa240802040305u611bb7edk3c757b73f40c1037@mail.gmail.com>
	 <-4694429725714512287@unknownmsgid>
	 <1ba2fa240802040321s515e61deld176d79eef2b444d@mail.gmail.com>
	 <-2417195033053015320@unknownmsgid>
	 <1ba2fa240802040326v425fe147y52f2d8731e3012cb@mail.gmail.com>
	 <1ba2fa240802040330o5b9ffb2dk32b28f7f959e49f4@mail.gmail.com>
	 <5358276387473684738@unknownmsgid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 4, 2008 1:53 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Tomas Winkler wrote:
>
> > Last question before I got another patch out?
> > So what will  be use of ieee80211_rate in tx_control then?
>
> Hmm? Not quite sure what you're asking. The tx_control has a pointer to
> the bitrate right now so that contains what bitrate the rate control
> algorithm selected (whether or not the hw downscales by itself).

So we add rate flags and pointer to bit rate structure?
Correct?

Thanks

> johannes
>
