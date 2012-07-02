Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52894 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab2GBUNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 16:13:14 -0400
Date: Mon, 2 Jul 2012 13:13:10 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vladimir Kondratiev <vkondrat_qca@qca.qualcomm.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC 60g 5/5] wireless: bitrate calculation for 60g
Message-ID: <20120702201310.GD21658@tux> (sfid-20120702_221318_606212_5CD55C93)
References: <1340882220-31768-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1340906876.4491.49.camel@jlt3.sipsolutions.net>
 <1703117.VxUDt2UvbQ@lx-vladimir>
 <2090114.iKoJhGKOAs@lx-vladimir>
 <20120702192804.GA21658@tux>
 <1341259898.19776.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1341259898.19776.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 02, 2012 at 10:11:38PM +0200, Johannes Berg wrote:
> On Mon, 2012-07-02 at 12:28 -0700, Luis R. Rodriguez wrote:
> 
> > > Expanding bitrate to u32 would break all userspace tools.
> > 
> > Unless userspace is told that a new high value is used. We could
> > for example attach a flag to tell userspace that a different
> > bitrate type should be used. We can also just get new userspace
> > to start embracing the new data type, and old userspace would
> > simply not support that bit rate.
> 
> The solution Vladimir proposed addresses all of that :-)

To the hip hop.. hippity hop !
 
 Luis
