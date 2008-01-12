Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:56976 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYALMrb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2008 07:47:31 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2390414wah.23
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jan 2008 04:47:30 -0800 (PST)
Message-ID: <1ba2fa240801120447l6b8475c3secff77ccb203852a@mail.gmail.com> (sfid-20080112_124734_087491_31B2F665)
Date: Sat, 12 Jan 2008 14:47:29 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 07/10] mac80211: A-MPDU Tx change tx_status to support Block Ack data
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, yi.zhu@intel.com
In-Reply-To: <-2543242200241674408@unknownmsgid>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
	 <11999857502772-git-send-email-ron.rindjunsky@intel.com>
	 <1200070609.3861.208.camel@johannes.berg>
	 <1ba2fa240801120343v2e60acc8kc56469106cf56df1@mail.gmail.com>
	 <-2543242200241674408@unknownmsgid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > This actually represents Block Ack frame. This is bitmap of received
> > and failed frames in the aggregation.
>
> Ok so each bit just represents "this frame of the block ack was received"?

I would rather word it as  'the 'frame of this aggregation was received/acked.'

> Might be worth elaborating the comment a bit.

Absolutely

> >> Broadcom hardware is able to give intermediate status notifications,
> >> would there be any use in those?
> >
> > Can you explain?
>
> Actually, I don't really know what the microcode there provides. I guess
> it tells you something like "I sent this frame, no TX errors occurred" or
> so...

Is this response to aggregation or just general response to TX?

Thanks
Tomas
