Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56288 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab2LCWsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 17:48:20 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so2380958vcd.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2012 14:48:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50BD2B46.5080706@candelatech.com>
References: <50BD2B46.5080706@candelatech.com>
Date: Mon, 3 Dec 2012 14:48:19 -0800
Message-ID: <CAJ-Vmokvkas-Hh0p274Ka2b-Wran3_-9iRB2azaPDN3-VxK4bg@mail.gmail.com> (sfid-20121203_234823_805346_6FAAF496)
Subject: Re: Allow over-riding regdomain in NIC when CFG80211_CERTIFICATION_ONUS
 is enabled?
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Would you please compare the CTL entries programmed into various
flavours of those NICs and tell me what's different?

(And if you can easily compare the rest of the OTP modifications, please do.)

I'd like to see whether there are any regulatory related information
changes to these NICs.



Adrian


On 3 December 2012 14:44, Ben Greear <greearb@candelatech.com> wrote:
> There are out-of-tree patches for ath9k (at least) that allow overriding the
> eeprom reg domain via a module option.
>
> Any chance something like that could make it upstream if it were dependent
> on CFG80211_CERTIFICATION_ONUS?
>
> (We recently got a batch of wpea-127n NICs with country-code of TW, which
> reminded me of this problem).
>
> Thanks,
> Ben
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
