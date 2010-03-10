Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:62062 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab0CJFir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:38:47 -0500
Subject: Re: [PATCH] mac80211: Fix (dynamic) power save entry
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "ext Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <43e72e891003090958k4413b171i911b163b8ee675ba@mail.gmail.com>
References: <1268137502-25339-1-git-send-email-juuso.oikarinen@nokia.com>
	 <43e72e891003090958k4413b171i911b163b8ee675ba@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Mar 2010 07:36:00 +0200
Message-ID: <1268199360.10120.442.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-03-09 at 18:58 +0100, ext Luis R. Rodriguez wrote:
> On Tue, Mar 9, 2010 at 4:25 AM, Juuso Oikarinen
> <juuso.oikarinen@nokia.com> wrote:
> > Currently hardware with !IEEE80211_HW_PS_NULLFUNC_STACK and
> > IEEE80211_HW_REPORTS_TX_ACK_STATUS will never enter PSM due to the
> > conditions in the power save entry functions.
> >
> > Fix those conditions.
> 
> Is this a stable fix, for 33?
> 
>   Luis

I have only tested this on our hardware (wl1271), which is configured as
stated above - though I tried to consider all other combinations of
those two flags too, but I haven't tested them.

-Juuso

