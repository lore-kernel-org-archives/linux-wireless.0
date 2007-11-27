Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:11492 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbXK0JeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 04:34:20 -0500
Received: by ug-out-1314.google.com with SMTP id z38so1190337ugc
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 01:34:18 -0800 (PST)
Message-ID: <c85cb4470711270134p34f02b6h8a4cfc8ca62c906e@mail.gmail.com> (sfid-20071127_093425_429678_7F828428)
Date: Tue, 27 Nov 2007 11:34:18 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 07/15] mac80211: adding 802.11n configuration flows
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <1196094968.4149.305.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
	 <11960864912718-git-send-email-ron.rindjunsky@intel.com>
	 <1196094968.4149.305.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > This patch configures the 802.11n mode of operation
> > internally in ieee80211_conf structure and in the low-level
> > driver as well (through op conf_ht).
> > It does not include AP configuration flows.
> >
> > Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>
> I look forward to seeing your bss config patches again :)

I also see them as important to the configuration flow efficiancy, and
will treat them accordingly.
