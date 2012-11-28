Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43708 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab2K1NDW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 08:03:22 -0500
Message-ID: <1354107826.9345.18.camel@jlt4.sipsolutions.net> (sfid-20121128_140326_378555_CD4EC07E)
Subject: Re: [PATCH] mac80211: Don't reinit rate control when mesh sta exists
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org
Date: Wed, 28 Nov 2012 14:03:46 +0100
In-Reply-To: <1354035793-23498-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20121127_180332_904175_6845BF48)
References: <1354035793-23498-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20121127_180332_904175_6845BF48)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 18:03 +0100, Helmut Schaa wrote:
> This fixes some unintended resets of the rate control statistics
> when minstrel_ht is used resulting in non-optimal throughput on mesh
> links.

Applied.

johannes

