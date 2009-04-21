Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:42875 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbZDUTlF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 15:41:05 -0400
Date: Tue, 21 Apr 2009 19:40:26 +0000
From: Chris Wright <chrisw@sous-sol.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, chunkeey@web.de, me@bobcopeland.com,
	linux-wireless@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH] atheros: fix propagation of bad EEPROM on
	regulatory init
Message-ID: <20090421194026.GC30916@hera.kernel.org> (sfid-20090421_214110_640009_10676DCD)
References: <1239673306-13954-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1239673306-13954-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Luis R. Rodriguez (lrodriguez@atheros.com) wrote:
> When the EEPROM is not in good condition we cannot continue so
> we currently bail out but only ath5k is bailing out properly.
> Both ath9k and ar9170 were proceeding and if a user were to run
> into this they'd see an obscure panic. Lets propagate the error
> as intended and make sure we inform the user by lifting the
> error message from debug to a kernel error.

Looks like this still isn't upstream.

> Stable note: You can find a port of this page here:
> 
> http://bombadil.infradead.org/~mcgrof/patches/ath9k/ath9k-fix-eeprom.patch.txt

(Thanks for the backport ;-)
-chris
