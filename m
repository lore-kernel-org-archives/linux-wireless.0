Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36844 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab2GCGuk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 02:50:40 -0400
Message-ID: <1341298233.5131.0.camel@jlt3.sipsolutions.net> (sfid-20120703_085043_623935_5C14A735)
Subject: Re: [PATCH 60g v2 0/5] Infrastructure for 60g (802.11ad)
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Vladimir Kondratiev <vkondrat_qca@qca.qualcomm.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 03 Jul 2012 08:50:33 +0200
In-Reply-To: <CAGRGNgVMLtOwsHxNsRkNO7tFUv7aQfSsHtw7JeXmLOF4X-oMHg@mail.gmail.com> (sfid-20120703_061620_511649_630FBEA3)
References: <1341210756-11054-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1341233662.19642.6.camel@jlt3.sipsolutions.net>
	 <1341233919.19642.7.camel@jlt3.sipsolutions.net>
	 <5202151.WBzXQarS2v@lx-vladimir>
	 <1341241685.19642.15.camel@jlt3.sipsolutions.net>
	 <CAGRGNgVMLtOwsHxNsRkNO7tFUv7aQfSsHtw7JeXmLOF4X-oMHg@mail.gmail.com>
	 (sfid-20120703_061620_511649_630FBEA3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-03 at 14:15 +1000, Julian Calaby wrote:

> > I think you should leave out the BITRATE value completely, not fill it
> > with 0.
> 
> Why not make it 65535?

Because that's confusing for userspace, that could very well be a valid
value, after all, in today's API.

johannes

