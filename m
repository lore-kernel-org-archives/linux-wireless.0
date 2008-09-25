Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:42960 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYIYGef (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 02:34:35 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: consolidate on a single escape_essid implementation
Date: Thu, 25 Sep 2008 08:34:07 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com> <20080924232453.GG9187@tesla> <20080924233234.GE3639@tuxdriver.com>
In-Reply-To: <20080924233234.GE3639@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809250834.07781.hs4233@mail.mn-solutions.de> (sfid-20080925_083440_223989_866F07A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> the libertas, ipw2100, and ipw2200 drivers don't use cfg80211
> (at least for now).

Yeah, Dan once spoke about using cfg80211 for libertas, but at 
that time I didn't saw the point.

Hmm, I actually don't see the point now :-)


But libertas (with debug code compiled in) uses escape_essid() 
and thus can easily be using the lib80211.
