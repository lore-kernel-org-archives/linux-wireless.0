Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45204 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbXINAqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2007 20:46:32 -0400
Subject: Re: [PATCH 2/3] Remove use of Atheros-specific modes from iwlwifi
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <43e72e890709131703p1260f31fx2a20ea45742583ae@mail.gmail.com>
References: <43e72e890709131703p1260f31fx2a20ea45742583ae@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 08:39:23 +0800
Message-Id: <1189730363.18944.24.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-09-13 at 20:03 -0400, Luis R. Rodriguez wrote:
> This patch removes usage of all Atheros turbo modes from iwlwifi.
> 
> This patch is intended for the iwlwifi branch of wireless-dev after a
> pull from origin/everything once
> 01-remove-atheros-turbo-from-mac80211.diff is applied. 

The atheros turbo mode code is already removed from my latest update for
iwlwifi. See my post yesterday with subject:

"[PATCH wireless-dev#iwlwifi] update iwlwifi drivers to 0.1.15"

Thanks,
-yi
