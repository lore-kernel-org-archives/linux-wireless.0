Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60226 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab0BXRTD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2010 12:19:03 -0500
Received: by pwj8 with SMTP id 8so4989665pwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2010 09:19:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201002241633.47090.helmut.schaa@googlemail.com>
References: <201002241633.47090.helmut.schaa@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 24 Feb 2010 09:18:40 -0800
Message-ID: <43e72e891002240918i152253c9o8130dc507d2dc03@mail.gmail.com>
Subject: Re: [PATCH] ath9k_htc: sync add_interface and remove_interface with
	mac80211
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: devel@linuxdriverproject.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 24, 2010 at 7:33 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> ath9k_htc does not build against current wireless-testing due to recent
> changes in mac80211 ("mac80211: remove struct ieee80211_if_init_conf").
>
> Fix this by updating the add_interface and remove_interface callbacks to
> use ieee80211_vif instead of ieee80211_if_init_conf.
>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Thanks! Applied and pushed out. I should note, since no one else has,
that ath9k_htc has gotten a huge face lift by now. Unfortunately the
entire new revamp was done through an internal private tree but from
what I gather submission upstream should happen soon.

  Luis
