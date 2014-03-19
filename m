Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37857 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721AbaCSNsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 09:48:52 -0400
Message-ID: <1395236924.4142.3.camel@jlt4.sipsolutions.net> (sfid-20140319_144855_544286_4358EA70)
Subject: Re: [PATCH] wireless: max MSDU size for DMG networks
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Wed, 19 Mar 2014 14:48:44 +0100
In-Reply-To: <1395227680-30007-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395227680-30007-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-03-19 at 13:14 +0200, Vladimir Kondratiev wrote:
> In the 802.11ad, aka DMG (Dynamic Multi-Gigabit), aka 60Ghz
> spec, maximum MSDU size extended to 7920 bytes.
> add #define for this.

Applied, thanks.

johannes

