Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33133 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbZGXX6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 19:58:04 -0400
Date: Fri, 24 Jul 2009 19:58:04 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Davide Pesavento <davidepesa@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: ath9k panic (ath_tx_rc_status)
Message-ID: <20090724235804.GB26729@bombadil.infradead.org>
References: <2da21fe50907241631o3bf02d35md09c341133f503d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2da21fe50907241631o3bf02d35md09c341133f503d2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 25, 2009 at 01:31:24AM +0200, Davide Pesavento wrote:
> Hi,
> 
> after the latest pull from wireless-testing
> (2.6.31-rc4-wl-29133-g1addf37) I always get a kernel panic with the
> ath9k driver. The panic happens as soon as I start wpa_supplicant
> (with -Dnl80211) or NetworkManager. I think that the kernel spits out
> some warnings (lockdep?) before crashing, but I haven't been able to
> capture them.
> This is a regression since my previous pull (2.6.31-rc3-wl... + something).

Yup, wrong patch applied/sent/fuckup. Try the patch posted.

  Luis
