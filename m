Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:65046 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYDCFPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 01:15:52 -0400
Received: by wf-out-1314.google.com with SMTP id 28so2975613wff.4
        for <linux-wireless@vger.kernel.org>; Wed, 02 Apr 2008 22:15:51 -0700 (PDT)
Message-ID: <1ba2fa240804022215q6fc006e5u2d11262221ac0f14@mail.gmail.com> (sfid-20080403_061600_040550_A79FFE1D)
Date: Thu, 3 Apr 2008 08:15:51 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: Chr <chunkeey@web.de>
Subject: Re: [PATCH] mac80211: add station aid into ieee80211_tx_control
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <200804030051.02391.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200804012145.18294.chunkeey@web.de>
	 <1207128858.10910.19.camel@johannes.berg>
	 <1ba2fa240804021305o502d7e22o5ffebd0f466e4188@mail.gmail.com>
	 <200804030051.02391.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 3, 2008 at 1:51 AM, Chr <chunkeey@web.de> wrote:
>
> On Wednesday 02 April 2008 22:05:46 Tomas Winkler wrote:
>  > On Wed, Apr 2, 2008 at 12:34 PM, Johannes Berg
>  >
>  > <johannes@sipsolutions.net> wrote:
>  > >  On Tue, 2008-04-01 at 21:45 +0200, Chr wrote:
>  > >  > This patch is necessary for the upcoming Accesspoint patch for p54.
>  > >
>  > >  Hm. I don't like increasing the tx control structure size but I guess
>  > >  you really need that :)
>  > >
>  > >  > Signed-off-by: Christian Lamparter <chunkeey@web.de>
>  > >
>  > >  Acked-by: Johannes Berg <johannes@sipsolutions.net>
>  > >
>  > >  Please CC the appropriate maintainers (i.e. at least me for mac80211) on
>  > >  code changes.
>  >
>  > Not sure why this cannot be bookeeped in the driver.
>  > Upon association AID is delivered to driver, so every packet that will
>  > be sent to this AP has this AID?
>
>  hmm? where? sta_notify just gives us the mac-address and a command.
>  (maybe you have mixed it up with set_tim?!)
>
>  Or do I miss something obvious here?

This patch series introduces this. It was posted week ago so I've
assumed it was already merged.

>[PATCH 1/4] mac80211: eliminate conf_ht
> [PATCH 2/4] iwlwifi: eliminate conf_ht
> [PATCH 3/4] mac80211: add association capabilty and timing
> info into bss_conf
> [PATCH 4/4] iwlwifi: Eliminate association from beacon



>  Regards,
>         Chr.
>
>
>
>
>
