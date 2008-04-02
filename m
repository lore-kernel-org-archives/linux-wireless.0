Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:62613 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbYDBUFt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 16:05:49 -0400
Received: by yw-out-2324.google.com with SMTP id 5so366438ywb.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Apr 2008 13:05:46 -0700 (PDT)
Message-ID: <1ba2fa240804021305o502d7e22o5ffebd0f466e4188@mail.gmail.com> (sfid-20080402_210616_909031_D98A33F8)
Date: Wed, 2 Apr 2008 23:05:46 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: add station aid into ieee80211_tx_control
Cc: Chr <chunkeey@web.de>, linux-wireless@vger.kernel.org,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <1207128858.10910.19.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200804012145.18294.chunkeey@web.de>
	 <1207128858.10910.19.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 2, 2008 at 12:34 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  On Tue, 2008-04-01 at 21:45 +0200, Chr wrote:
>  > This patch is necessary for the upcoming Accesspoint patch for p54.
>
>  Hm. I don't like increasing the tx control structure size but I guess
>  you really need that :)
>
>
>  > Signed-off-by: Christian Lamparter <chunkeey@web.de>
>
>  Acked-by: Johannes Berg <johannes@sipsolutions.net>
>
>  Please CC the appropriate maintainers (i.e. at least me for mac80211) on
>  code changes.
>

Not sure why this cannot be bookeeped in the driver.
Upon association AID is delivered to driver, so every packet that will
be sent to this AP has this AID?
