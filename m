Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:41303 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752016AbeAZPFe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 10:05:34 -0500
Received: by mail-qt0-f181.google.com with SMTP id i1so1934226qtj.8
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jan 2018 07:05:34 -0800 (PST)
Date: Fri, 26 Jan 2018 07:05:30 -0800
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211_hwsim: don't use WQ_MEM_RECLAIM
Message-ID: <20180126150530.GK17457@devbig577.frc2.facebook.com> (sfid-20180126_160538_513586_4C9A5632)
References: <20180124074051.19939-1-johannes@sipsolutions.net>
 <7eb10bf1-7825-3dae-b813-d912e6670440@uni-rostock.de>
 <1516790786.2508.43.camel@sipsolutions.net>
 <CAF7Mx6oASGjDrzVq4_t8Wt-DU7Zap1tcpz5vU7bk-Q5qzg4V=g@mail.gmail.com>
 <CAF7Mx6o_Y0AeGQfhGKMkSxUHtRNyGaHh3g-TyvusJmsYyckFZg@mail.gmail.com>
 <CAF7Mx6rg2XOOG0mZxnKiM_1ToB36Yc2A=sKQfN7drLsr3+4crw@mail.gmail.com>
 <5A6A3BFC.5090305@broadcom.com>
 <1516914086.2189.9.camel@sipsolutions.net>
 <20180125222650.GJ17457@devbig577.frc2.facebook.com>
 <1516954082.2189.14.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1516954082.2189.14.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Fri, Jan 26, 2018 at 09:08:02AM +0100, Johannes Berg wrote:
> Not that you mention it ... Honestly though, wifi connections break all
> the time, so not sure you'd really want that. But anyway, that's what
> we have.

I'd be a lot happier to remove WQ_MEM_RECLAIM from wireless drivers
too, and glancing the code, it looked like there already are so many
holes that whether having that flag or not shouldn't matter all that
much.  It was just difficult for me to make a case for removing it
preemptively.  If you're up for it, please be my guest.

Thanks.

-- 
tejun
