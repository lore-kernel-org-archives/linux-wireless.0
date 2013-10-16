Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:63951 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760230Ab3JPJvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 05:51:20 -0400
MIME-Version: 1.0
In-Reply-To: <577936357.20131016104505@eikelenboom.it>
References: <577936357.20131016104505@eikelenboom.it>
Date: Wed, 16 Oct 2013 12:51:18 +0300
Message-ID: <CANUX_P0xkcm=WhRcBeaFZvn6HLE+MLXvFxVpmeQGHUMF1-MMOw@mail.gmail.com> (sfid-20131016_115128_662738_4A76B8FC)
Subject: Re: iwlwifi Centrino Advanced-N 6235, setting regulatory domain with
 iw reg set XX doesn't work.
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi
>
> I seem to have to take a second hurdle in using my Centrino Advanced-N 6235 with linux.
>
> I'm trying to set the regulatory domain (currenly world domain (00))
> But a "iw reg set US" or "iw reg set NL" does not succeed.
>
> # iw reg get
> country 00:
>         (2402 - 2472 @ 40), (6, 20)
>         (2457 - 2482 @ 40), (6, 20), PASSIVE-SCAN, NO-IBSS
>         (2474 - 2494 @ 20), (6, 20), NO-OFDM, PASSIVE-SCAN, NO-IBSS
>         (5170 - 5250 @ 80), (6, 20), PASSIVE-SCAN, NO-IBSS
>         (5735 - 5835 @ 80), (6, 20), PASSIVE-SCAN, NO-IBSS
>         (57240 - 63720 @ 2160), (N/A, 0)
>
> # iw reg set US
>
> # iw reg get
> country 00:
>         (2402 - 2472 @ 40), (6, 20)
>         (2457 - 2482 @ 40), (6, 20), PASSIVE-SCAN, NO-IBSS
>         (2474 - 2494 @ 20), (6, 20), NO-OFDM, PASSIVE-SCAN, NO-IBSS
>         (5170 - 5250 @ 80), (6, 20), PASSIVE-SCAN, NO-IBSS
>         (5735 - 5835 @ 80), (6, 20), PASSIVE-SCAN, NO-IBSS
>         (57240 - 63720 @ 2160), (N/A, 0)
>
>
> The only thing is this message in dmesg:
> "cfg80211: Pending regulatory request, waiting for it to be processed...".
>
> I did enable some of the kernel wifi debug options, but there is no error or more informatie.
> But it doesn't get set as you can see above.
>

This is most probably not related to the device itself.
Luis?
