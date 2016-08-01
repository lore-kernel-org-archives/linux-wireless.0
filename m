Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34203 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbcHAMaS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 08:30:18 -0400
Message-ID: <1470054044.17912.5.camel@sipsolutions.net> (sfid-20160801_143043_304056_B4B6D5B2)
Subject: Re: [PATCH 2/3 v6] mac80211: Refactor ieee80211_iface_work
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Briskin <br.shurik@gmail.com>, linux-wireless@vger.kernel.org
Date: Mon, 01 Aug 2016 14:20:44 +0200
In-Reply-To: <1468693140-19483-2-git-send-email-br.shurik@gmail.com> (sfid-20160716_201943_971404_A417FEF2)
References: <1468693140-19483-1-git-send-email-br.shurik@gmail.com>
	 <1468693140-19483-2-git-send-email-br.shurik@gmail.com>
	 (sfid-20160716_201943_971404_A417FEF2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Added ieee80211_iface_work_handle_frame_control.

That function name doesn't really make sense - handle_mgmt() perhaps?

johannes
