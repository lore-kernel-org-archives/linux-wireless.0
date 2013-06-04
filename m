Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56385 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759292Ab3FDGwD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 02:52:03 -0400
Message-ID: <1370328716.8287.7.camel@jlt4.sipsolutions.net> (sfid-20130604_085206_454511_72DB0176)
Subject: Re: [PATCH v8] P2P find phase offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Tue, 04 Jun 2013 08:51:56 +0200
In-Reply-To: <1370328271-9523-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1370328271-9523-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-04 at 09:44 +0300, Vladimir Kondratiev wrote:
> - Fix kerneldoc for start_p2p_find/stop_p2p_find (forgotten '@')
> - rebase

So you just took it from my wip branch? ;-)

I also fixed another small issue -- genlmsg_end() can't return <0. I'm
waiting for a colleague to take a quick look but then I'll put it onto
the master branch.

johannes

