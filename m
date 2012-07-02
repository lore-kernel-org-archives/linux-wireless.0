Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35086 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab2GBULp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 16:11:45 -0400
Message-ID: <1341259898.19776.0.camel@jlt3.sipsolutions.net> (sfid-20120702_221148_173426_D1590C5B)
Subject: Re: [RFC 60g 5/5] wireless: bitrate calculation for 60g
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: Vladimir Kondratiev <vkondrat_qca@qca.qualcomm.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 02 Jul 2012 22:11:38 +0200
In-Reply-To: <20120702192804.GA21658@tux>
References: <1340882220-31768-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1340906876.4491.49.camel@jlt3.sipsolutions.net>
	 <1703117.VxUDt2UvbQ@lx-vladimir> <2090114.iKoJhGKOAs@lx-vladimir>
	 <20120702192804.GA21658@tux>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-02 at 12:28 -0700, Luis R. Rodriguez wrote:

> > Expanding bitrate to u32 would break all userspace tools.
> 
> Unless userspace is told that a new high value is used. We could
> for example attach a flag to tell userspace that a different
> bitrate type should be used. We can also just get new userspace
> to start embracing the new data type, and old userspace would
> simply not support that bit rate.

The solution Vladimir proposed addresses all of that :-)

johannes

