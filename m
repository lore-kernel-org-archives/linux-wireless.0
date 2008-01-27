Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:35604 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbYA0RZj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 12:25:39 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1428003rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jan 2008 09:25:38 -0800 (PST)
Message-ID: <c85cb4470801270925p331a3ea0p2df5dae7da0ff7f0@mail.gmail.com> (sfid-20080127_172541_486185_F5B0AE2E)
Date: Sun, 27 Jan 2008 19:25:38 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 03/12] mac80211: A-MPDU Tx adding basic functionality
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1201167039.3454.61.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
	 <12009163393182-git-send-email-ron.rindjunsky@intel.com>
	 <1201167039.3454.61.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +     /* FIXME: need a better way to ensure that TX flow won't interrupt us*/
> > +     /* until the end of the call to requeue function */
> > +     spin_lock_bh(&local->mdev->queue_lock);
>
> What sort of better way could we have?
>

this comments is a left over, i'll remove it, thanks.

> johannes
>
>
