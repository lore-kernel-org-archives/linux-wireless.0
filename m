Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33773 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab2GBMyD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 08:54:03 -0400
Message-ID: <1341233640.19642.5.camel@jlt3.sipsolutions.net> (sfid-20120702_145408_419599_FB418A61)
Subject: Re: [PATCH 60g v2 5/5] wireless: bitrate calculation for 60g
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Mon, 02 Jul 2012 14:54:00 +0200
In-Reply-To: <1341210756-11054-6-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1341210756-11054-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1341210756-11054-6-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-02 at 09:32 +0300, Vladimir Kondratiev wrote:

> +#if 0
> +		/*
> +		 * TODO: How to report this bitrate?
> +		 * It don't fit into u16
> +		 */
> +		[24] = 67568, /* 6756.75 mbps */
> +#endif

So how do you plan to address this todo? I think we need to have a new
U32 attribute for the bitrate and then put this when the value is too
large etc.

johannes

