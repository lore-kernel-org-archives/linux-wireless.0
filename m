Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51685 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab1DALli (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 07:41:38 -0400
Received: by fxm17 with SMTP id 17so2530609fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 04:41:37 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: hostapd & mac80211: too many probe responses
Date: Fri, 1 Apr 2011 13:39:46 +0200
Cc: linux-wireless@vger.kernel.org
References: <201104011237.21983.helmut.schaa@googlemail.com> <201104011255.59751.helmut.schaa@googlemail.com> <1301655634.3832.18.camel@jlt3.sipsolutions.net>
In-Reply-To: <1301655634.3832.18.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201104011339.46556.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 1. April 2011 schrieb Johannes Berg:
> On Fri, 2011-04-01 at 12:55 +0200, Helmut Schaa wrote:
> 
> > > Looks like we broke that then, IEEE80211_RX_CMNTR was intended to do
> > > this. 
> > 
> > Ah, I see. I'll do some more debugging in that direction first ...
> 
> I think the 'rx->flags = 0;' thing is just wrong.

Uhhm, yep. I'll test and send a patch.

Thanks Johannes.
