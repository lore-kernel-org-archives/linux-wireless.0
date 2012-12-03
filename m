Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:52832 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab2LCXQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 18:16:25 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so2778691lag.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2012 15:16:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50BD2B46.5080706@candelatech.com>
References: <50BD2B46.5080706@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 3 Dec 2012 15:16:03 -0800
Message-ID: <CAB=NE6XQGKTFq_yQt7QuFmozNCDT42w7B8qSdv_FY4arOQziZg@mail.gmail.com> (sfid-20121204_001629_219859_3F5A2879)
Subject: Re: Allow over-riding regdomain in NIC when CFG80211_CERTIFICATION_ONUS
 is enabled?
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 3, 2012 at 2:44 PM, Ben Greear <greearb@candelatech.com> wrote:
> There are out-of-tree patches for ath9k (at least) that allow overriding the
> eeprom reg domain via a module option.
>
> Any chance something like that could make it upstream if it were dependent
> on CFG80211_CERTIFICATION_ONUS?
>
> (We recently got a batch of wpea-127n NICs with country-code of TW, which
> reminded me of this problem).

I think it would be reasonable, but note Adrian's points. We likely
would need then only to be able to change regulatory domains for only
regulatory domains that match the CTLs programmed in. I'll also note
that the default CTL is actually a high value rather than no
transmit...

  Luis
