Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60275 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933084AbaFCUBo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2014 16:01:44 -0400
Message-ID: <1401825693.4157.44.camel@jlt4.sipsolutions.net> (sfid-20140603_220202_175630_3BBF5CAF)
Subject: Re: [RFC 1/4] cfg80211: Add channel flags limiting availability to
 OCB mode only
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de,
	Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Tue, 03 Jun 2014 22:01:33 +0200
In-Reply-To: <1401468984-24575-2-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140530_185636_258190_E00F48D4)
References: <1401468984-24575-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1401468984-24575-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140530_185636_258190_E00F48D4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-30 at 18:56 +0200, Rostislav Lisovy wrote:
> IEEE 802.11p operates in its own 5.9GHz band. When there will
> be a record for the 5.9GHz band in the regulatory daemon,
> it must be limited to the OCB mode only -- using the newly
> added flags.

Is this really a *regulatory* limitation? Rather than a limitation
elsewhere, e.g. the spec?

johannes

