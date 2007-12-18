Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:15527 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbXLRJYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 04:24:07 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1952184fkz.5
        for <linux-wireless@vger.kernel.org>; Tue, 18 Dec 2007 01:24:04 -0800 (PST)
Message-ID: <c85cb4470712180124l422c04d1g5ab3a8f67e245199@mail.gmail.com> (sfid-20071218_092419_124293_911C6B4B)
Date: Tue, 18 Dec 2007 11:24:04 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: pass in PS_POLL frames
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1197913576.4885.57.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1197278205280-git-send-email-ron.rindjunsky@intel.com>
	 <1197913576.4885.57.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +     if (sdata->type == IEEE80211_IF_TYPE_STA)
> > +             return TXRX_DROP;
>
> Should we maybe do the test explicitly for when we want it, i.e.
> AP/VLAN/IBSS cases? Just thinking of the mesh networking stuff etc.
> that's being added...

no problem, i'll send it over. currently i see only AP mode as relevant.

>
> Other than that, looks fine.
>
> johannes
>
>
