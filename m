Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39510 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545Ab0K3LKI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 06:10:08 -0500
Received: by bwz15 with SMTP id 15so4888210bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 03:10:07 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH 1/2] cfg80211: Add new BSS attribute ht_opmode
Date: Tue, 30 Nov 2010 12:08:58 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1290166826-27063-1-git-send-email-helmut.schaa@googlemail.com> <1290583289.3790.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1290583289.3790.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011301208.59195.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch 24 November 2010 schrieb Johannes Berg:
> On Fri, 2010-11-19 at 12:40 +0100, Helmut Schaa wrote:
> > Add a new BSS attribute to allow hostapd to set the current HT opmode.
> > Otherwise drivers won't be able to set up protection for HT rates in
> > AP mode.
> > 
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> > ---
> > 
> > Not sure if we also want to pass in some other parts of the HT Operation
> > IE or maybe the whole IE?
> > 
> > At the moment the HT opmode is sufficient but in the future we might
> > want to support STBC beaconing and so on. Passing the whole IE would
> > not require any new interfaces later but also makes the interface less
> > nice IMO :)
> > 
> > I'll send a patch for hostapd as soon as the interface is agreed on.
> 
> This seems fine to me. Any opinion from Jouni?

Jouni, any comment from your side?

Thanks,
Helmut
