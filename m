Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52129 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331Ab2AJPeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 10:34:37 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Rkdie-0000my-BO
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 16:34:36 +0100
Subject: Re: [RFC/RFT 0/3] auth/assoc redesign
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <20120110153048.612308160@sipsolutions.net> (sfid-20120110_163315_162452_01A5E7B6)
References: <20120110153048.612308160@sipsolutions.net>
	 (sfid-20120110_163315_162452_01A5E7B6)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Jan 2012 16:34:36 +0100
Message-ID: <1326209676.3438.6.camel@jlt3.sipsolutions.net> (sfid-20120110_163439_521683_A60D98A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-10 at 16:30 +0100, Johannes Berg wrote:
> So ... I've talked about this long enough, here we go.

Btw. It's also a net code removal overall:

 Documentation/DocBook/80211.tmpl |    1 
 include/net/cfg80211.h           |   51 -
 net/mac80211/Makefile            |    4 
 net/mac80211/cfg.c               |    6 
 net/mac80211/ieee80211_i.h       |   77 +-
 net/mac80211/iface.c             |    4 
 net/mac80211/main.c              |   10 
 net/mac80211/mlme.c              | 1356 ++++++++++++++++++++++++++++-----------
 net/mac80211/rx.c                |    9 
 net/mac80211/work.c              |  815 -----------------------
 net/wireless/core.h              |   20 
 net/wireless/mlme.c              |  320 +--------
 net/wireless/nl80211.c           |   28 
 net/wireless/scan.c              |   12 
 net/wireless/sme.c               |   48 -
 15 files changed, 1167 insertions(+), 1594 deletions(-)

johannes

