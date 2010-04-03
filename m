Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53097 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752249Ab0DCHtk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Apr 2010 03:49:40 -0400
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Convert arc4 from a cipher into a block cipher
Date: Sat,  3 Apr 2010 09:49:22 +0200
Message-Id: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series converts arc4 into a block cipher and converts all its
users (except those in staging) to use it. The first two patches ensure
that two implementations can coexist, the following patches convert each
user so we remain bisectable.
- lib80211_crypt_tkip was tested with ipw2200
- mac80211 was tested with zd1211rw

Sebastian

