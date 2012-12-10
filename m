Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:9295 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab2LJMP7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 07:15:59 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless-regdb: add regulatory rule for ETSI members on 60gHz band
Date: Mon, 10 Dec 2012 14:15:55 +0200
Message-ID: <2225032.pbhpKMrF3f@lx-vladimir> (sfid-20121210_131607_448975_D9713B15)
In-Reply-To: <1355139107.9857.15.camel@jlt4.sipsolutions.net>
References: <8774585.BvFN3Opv12@lx-vladimir> <1424987.QUc2GD1qWX@lx-vladimir> <1355139107.9857.15.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, December 10, 2012 12:31:47 PM Johannes Berg wrote:
> does the kernel understand the two rules with
> different TX power/outdoor restriction properly?

Oh no! You are right, kernel won't get it.

In general: What is the right way to specify different restrictions
for indoor and outdoor?

In this particular case, would it be appropriate to specify
indoor usage only, as 60g wi-fi will be used mostly indoor?

Thanks, Vladimir
