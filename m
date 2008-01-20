Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:12002 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbYATPgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 10:36:54 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1473954rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jan 2008 07:36:53 -0800 (PST)
Message-ID: <c85cb4470801200736o14601f10w8c3e4cf6f03223c3@mail.gmail.com> (sfid-20080120_153656_734234_FBD443AA)
Date: Sun, 20 Jan 2008 17:36:53 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 03/12 v2] mac80211: A-MPDU Tx adding basic functionality
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1200617343.5716.15.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1200508860699-git-send-email-ron.rindjunsky@intel.com>
	 <1200508864774-git-send-email-ron.rindjunsky@intel.com>
	 <1200617343.5716.15.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> > +     ret = ieee80211_ht_agg_queue_add(local, sta, tid);
>
> Not going to compile since you haven't added that function yet... You
> should at least already have no stubs and later move them into the
> #ifndef QoS section.
>

ok. i pushed this calls to the queue patch
