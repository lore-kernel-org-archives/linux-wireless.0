Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1380 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab2GBT2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 15:28:08 -0400
Date: Mon, 2 Jul 2012 12:28:04 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Vladimir Kondratiev <vkondrat_qca@qca.qualcomm.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC 60g 5/5] wireless: bitrate calculation for 60g
Message-ID: <20120702192804.GA21658@tux> (sfid-20120702_212813_049559_FA8FC9DF)
References: <1340882220-31768-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1340906876.4491.49.camel@jlt3.sipsolutions.net>
 <1703117.VxUDt2UvbQ@lx-vladimir>
 <2090114.iKoJhGKOAs@lx-vladimir>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <2090114.iKoJhGKOAs@lx-vladimir>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 01, 2012 at 01:35:06PM +0300, Vladimir Kondratiev wrote:
>    I am looking how to handle it the best way. For quick solution, I tend to
>    just say I won't support this MCS.

Lets instead try to address shortcomings of the interface.

> Expanding bitrate to u32 would break all userspace tools.

Unless userspace is told that a new high value is used. We could
for example attach a flag to tell userspace that a different
bitrate type should be used. We can also just get new userspace
to start embracing the new data type, and old userspace would
simply not support that bit rate.

  Luis
