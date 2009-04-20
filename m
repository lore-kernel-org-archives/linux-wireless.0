Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out8.libero.it ([212.52.84.108]:49235 "EHLO
	cp-out8.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbZDTV6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:58:55 -0400
From: Fabio Rossi <rossi.f@inwind.it>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/4] mac80211 powersave work
Date: Mon, 20 Apr 2009 23:55:46 +0200
Cc: Davide Pesavento <davidepesa@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20090416111723.904720021@sipsolutions.net> <2da21fe50904201326m3d843b64u1c3b56d2593bb7cb@mail.gmail.com> <1240259450.4632.20.camel@johannes.local>
In-Reply-To: <1240259450.4632.20.camel@johannes.local>
MIME-Version: 1.0
Message-Id: <200904202355.46803.rossi.f@inwind.it> (sfid-20090420_235917_781692_6B049F62)
Content-Type: text/plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 20 April 2009, Johannes Berg wrote:

> But if that's just a hardware/driver bug shouldn't the driver disable PS
> for that combination? It seems wrong to disable PS in the stack by
> default just because one driver has a problem with it, when that driver
> could just unset the PS support bit.

I think that a printk notice message could be useful to state that the 
powersave management is active (of course with DEBUG on, at least during the 
first larger-user-base test period).

Fabio
