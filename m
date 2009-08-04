Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33631 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140AbZHDV6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 17:58:45 -0400
Received: by mail-bw0-f219.google.com with SMTP id 19so3349532bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 14:58:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249417983.24787.8.camel@johannes.local>
References: <83a869cd0907311335h3065547aqc736573a663b6d42@mail.gmail.com>
	 <200907312238.15705.mb@bu3sch.de>
	 <20090804160558.GC4995@tuxdriver.com>
	 <200908042227.46237.mb@bu3sch.de>
	 <1249417983.24787.8.camel@johannes.local>
Date: Tue, 4 Aug 2009 23:58:45 +0200
Message-ID: <83a869cd0908041458n1f23f100pee5a6b3c4c3f11e4@mail.gmail.com>
Subject: Re: [PATCH] remove wrong probe_resp_plcp write
From: gregor kowski <gregor.kowski@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/4/09, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2009-08-04 at 22:27 +0200, Michael Buesch wrote:
>
> Just remove it -- if we need it back we can find it in the git archives,
> and it's rather unlikely that we're going to add that functionality to
> mac80211 and hostapd unless you'll push it.
>
What should be removed ?
b43_write_probe_resp_template and b43_write_probe_resp_plcp ?

Gregor
