Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33806 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2GBNCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 09:02:05 -0400
Message-ID: <1341234124.19642.8.camel@jlt3.sipsolutions.net> (sfid-20120702_150209_649737_B851DDC6)
Subject: Re: [PATCH 60g v2 2/5] wireless: rate check logic for 60g
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Mon, 02 Jul 2012 15:02:04 +0200
In-Reply-To: <1341210756-11054-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120702_083300_139436_F1DC44E4)
References: <1341210756-11054-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1341210756-11054-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 (sfid-20120702_083300_139436_F1DC44E4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-02 at 09:32 +0300, Vladimir Kondratiev wrote:
> On the 60g band, there is no 'basic rates'. Only MCS used.
> Instead of mandatory basic rates, standard requires support for
> mandatory MCS 1..4

I also fixed this ... this code has nothing to do with "basic rates"...

johannes

