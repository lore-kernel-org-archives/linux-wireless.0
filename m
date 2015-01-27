Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34442 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbbA0Qey (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 11:34:54 -0500
Message-ID: <1422376486.1890.66.camel@sipsolutions.net> (sfid-20150127_173459_621487_25E12931)
Subject: Re: [PATCH] cfg80211: fix world_regdom's n_reg_rules
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Jan 2015 17:34:46 +0100
In-Reply-To: <1422375051-20709-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1422375051-20709-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-27 at 18:10 +0200, Vladimir Kondratiev wrote:
> In the commit:
> 131a19b - regulatory: enable channels 52-64 and 100-144 for world roaming

please use 12 hex digits to refer to commits.

> 2 entries added to the world_regdom.reg_rules, while
> world_regdom.n_reg_rules was not updated to reflect array size.
> Fix it.
> 
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Should it be Cc stable? And you should probably add a Fixes: tag.

johannes


