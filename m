Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53024 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab3CGKLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 05:11:13 -0500
Message-ID: <1362651067.8694.23.camel@jlt4.sipsolutions.net> (sfid-20130307_111118_539946_DC71C92D)
Subject: Re: [RFC] P2P find offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 07 Mar 2013 11:11:07 +0100
In-Reply-To: <1362650938.8694.21.camel@jlt4.sipsolutions.net> (sfid-20130307_110912_537897_94701872)
References: <3408094.SIuA27EmQ5@lx-vladimir>
	 <1362412079.21028.34.camel@jlt4.sipsolutions.net>
	 <1686131.738LDv7O6j@lx-vladimir> <7076584.7eoLUXqF3A@lx-vladimir>
	 <1362650938.8694.21.camel@jlt4.sipsolutions.net>
	 (sfid-20130307_110912_537897_94701872)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also ...

I really don't think this should be supported on IBSS/AP/... netdevs.
Seems like the only reasonable ones are P2P_DEVICE and STATION, although
it would probably be good to have feature advertising for both, or
document that if P2P_DEVICE is supported at all then this doesn't have
to be supported on STATION interfaces, or so.

And then ... should this really be allowed to be concurrent with
scanning/remain-on-channel? You haven't done any checking or
documentation, so users and driver authors are left to guess.

johannes

