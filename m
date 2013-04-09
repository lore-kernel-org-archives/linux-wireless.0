Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55495 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934554Ab3DIGwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 02:52:42 -0400
Message-ID: <1365490352.8465.3.camel@jlt4.sipsolutions.net> (sfid-20130409_085244_739393_C8F383C4)
Subject: Re: [PATCH 3/3] wireless-regdb: add VHT channels 1..3 to world
 regdom
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linville@tuxdriver.com, qca_vkondrat@qca.qualcomm.com,
	yunsenw@qca.qualcomm.com, kandala@qca.qualcomm.com,
	wireless-regdb@lists.infradead.org, green@qca.qualcomm.com,
	linux-wireless@vger.kernel.org
Date: Tue, 09 Apr 2013 08:52:32 +0200
In-Reply-To: <1365486778-2336-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20130409_075322_170119_582B1385)
References: <1365486778-2336-1-git-send-email-mcgrof@do-not-panic.com>
	 <1365486778-2336-4-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20130409_075322_170119_582B1385)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-08 at 22:52 -0700, Luis R. Rodriguez wrote:

> +	# IEEE 802.11ad (60gHz), channels 1..3
> +	(57240 - 63720 @ 2160), (N/A, 0)

Also -- GHz, not gHz :)

johannes

