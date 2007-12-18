Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.189]:13953 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbXLRNnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 08:43:22 -0500
Received: by mu-out-0910.google.com with SMTP id i10so3475148mue.5
        for <linux-wireless@vger.kernel.org>; Tue, 18 Dec 2007 05:43:21 -0800 (PST)
Message-ID: <c85cb4470712180543k502e24e3pbecc0a70826e2cad@mail.gmail.com> (sfid-20071218_134330_530606_6EDBC529)
Date: Tue, 18 Dec 2007 15:43:20 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 4/8] mac80211: A-MPDU Rx MLME data initialization
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1197914943.4885.78.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070784033-git-send-email-ron.rindjunsky@intel.com>
	 <1197914943.4885.78.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> > +     spin_lock_init(&sta->ampdu_mlme.ampdu_rx);
> > +     for (i = 0; i < STA_TID_NUM; i++) {
> > +             sta->timer_to_tid[i] = i;
>
> Please add a comment here as well that this *must* be initialised to the
> identity mapping and have the comment mention the user(s).
>

will add a comment
