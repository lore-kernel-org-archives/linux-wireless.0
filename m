Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:51250 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeAPNc2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 08:32:28 -0500
Message-ID: <1516109545.410.46.camel@sipsolutions.net> (sfid-20180116_143231_957120_964F2E8A)
Subject: Re: [RFC v2 4/5] nl80211: Implement TX of control port frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org,
        Jouni Malinen <j@w1.fi>
Date: Tue, 16 Jan 2018 14:32:25 +0100
In-Reply-To: <ec908dbe-a54d-d145-9b49-964f03b5ff22@gmail.com> (sfid-20180115_170319_483645_D0AA6C29)
References: <20180110170938.2341-1-denkenz@gmail.com>
         <20180110170938.2341-5-denkenz@gmail.com>
         <1516022078.410.33.camel@sipsolutions.net>
         <ec908dbe-a54d-d145-9b49-964f03b5ff22@gmail.com>
         (sfid-20180115_170319_483645_D0AA6C29)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > > +	switch (wdev->iftype) {
> > > +	case NL80211_IFTYPE_STATION:
> > > +		if (wdev->current_bss)
> > 
> > err, !current_bss?
> > 
> 
> Seems fine to me?  There's a break after that if statement.

Right, got confused, sorry.

johannes
