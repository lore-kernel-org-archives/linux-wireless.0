Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36267 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZBTGIl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 01:08:41 -0500
Date: Fri, 20 Feb 2009 01:08:35 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	marcel@holtmann.org, kalle.valo@nokia.com, kyle@mcmartin.ca,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/5] cfg80211: enhance world roaming
Message-ID: <20090220060835.GA23428@bombadil.infradead.org> (sfid-20090220_070845_046300_2B1EFAB1)
References: <1235109874-3966-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1235109874-3966-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 20, 2009 at 01:04:29AM -0500, Luis R. Rodriguez wrote:
> This series enhances world roaming through a few set of
> enhancements. We world roam when OLD_REG is disabled and
> CRDA _is_ installed and when we have had no regulatory
> hint from anything yet (country IE, userspace, or driver).

> If you lack CRDA and you also have OLD_REG you also world roam. 

I mean if you have CRDA and you have OLD_REG _disabled_ you also world
roam.

  Luis

