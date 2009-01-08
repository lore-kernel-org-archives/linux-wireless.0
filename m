Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:41419 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696AbZAHJRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 04:17:04 -0500
Date: Thu, 8 Jan 2009 11:16:51 +0200
From: Jouni Malinen <j@w1.fi>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: [PATCH 2/6] mac80211: remove an unused parameter in
	ieee80211_rx_mgmt_probe_req().
Message-ID: <20090108091651.GB7009@jm.kir.nu> (sfid-20090108_101719_303540_73C4DE55)
References: <eb3ff54b0901060050q42b2883ew177df650e36bf1b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <eb3ff54b0901060050q42b2883ew177df650e36bf1b9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 06, 2009 at 10:50:51AM +0200, Rami Rosen wrote:
> This patch removes an unused parameter (rx_status) in
> ieee80211_rx_mgmt_probe_req(),
> in mlme.c.

I could think of some uses for this information in deciding what to
include in (or more likely, which TX parameters to use for) Probe
Response, but this parameter can be easily added back should someone
ever end up implementing this, so I'm not against removing it now.

-- 
Jouni Malinen                                            PGP id EFC895FA
