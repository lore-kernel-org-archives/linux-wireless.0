Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43691 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab1CQSAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 14:00:18 -0400
Subject: RE: [PATCH 00/11] remove configuration APIs from debugfs (part 2)
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F704307FA4C35A9@SC-VEXCH1.marvell.com>
References: <1300320574-10793-1-git-send-email-bzhao@marvell.com>
	 <1300354343.3774.1.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F704307FA4C35A9@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 19:00:14 +0100
Message-ID: <1300384814.3774.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > I obviously have no issues with this, but you might want to keep the git
> > history for afterwards for when I suppose you'll start working on actual
> > APIs for these features?
> 
> To keep the git history, I can send a 'pull request' to John after we
> clean up the debugfs APIs and fix the set_default_key() function.

I don't think we need to or should keep the history upstream, it'd be
nicer as a smaller patch IMHO, but I'll let John make that call, just
saying that you shouldn't throw it away since I hope you'll work on
having these features exposed "properly" :-)

johannes


