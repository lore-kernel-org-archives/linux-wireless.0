Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40466 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2LJMdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 07:33:41 -0500
Message-ID: <1355142835.9857.19.camel@jlt4.sipsolutions.net> (sfid-20121210_133344_447516_E91F43D6)
Subject: Re: [PATCH] wireless-regdb: add regulatory rule for ETSI members on
 60gHz band
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linville@tuxdriver.com, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 13:33:55 +0100
In-Reply-To: <2225032.pbhpKMrF3f@lx-vladimir>
References: <8774585.BvFN3Opv12@lx-vladimir>
	 <1424987.QUc2GD1qWX@lx-vladimir>
	 <1355139107.9857.15.camel@jlt4.sipsolutions.net>
	 <2225032.pbhpKMrF3f@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-12-10 at 14:15 +0200, Vladimir Kondratiev wrote:
> On Monday, December 10, 2012 12:31:47 PM Johannes Berg wrote:
> > does the kernel understand the two rules with
> > different TX power/outdoor restriction properly?
> 
> Oh no! You are right, kernel won't get it.
> 
> In general: What is the right way to specify different restrictions
> for indoor and outdoor?

I don't know if we have a way to handle it right now ...

> In this particular case, would it be appropriate to specify
> indoor usage only, as 60g wi-fi will be used mostly indoor?

With the current rule system that'd be the only way, I think.

We should keep it in mind for the new rule system.

However, I notice there are also spectral power limits, that might be
relevant in case anyone ever uses the database for narrower channels?

johannes

