Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1FYNHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2011 09:07:12 -0400
Subject: Re: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom
 reservation
From: Johannes Berg <johannes@sipsolutions.net>
To: yogeshp <yogeshp@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
In-Reply-To: <4E045317.4040208@marvell.com>
References: <7DDF37406E10F0438561DBB78326DF3902F5D190E2@SC-VEXCH1.marvell.com>
	 <1308590980.4322.19.camel@jlt3.sipsolutions.net>
	 <20110621130305.GB32464@hertz.marvell.com>
	 <1308663814.4276.3.camel@jlt3.sipsolutions.net>
	 <20110621141017.GC32464@hertz.marvell.com>
	 <1308667215.4276.7.camel@jlt3.sipsolutions.net>
	 <20110621163351.GD32464@hertz.marvell.com>
	 <20110622071743.GA4087@hertz.marvell.com>
	 <20110622123118.GA4800@hertz.marvell.com>
	 <1308746965.29571.1.camel@jlt3.sipsolutions.net>
	 <20110622125853.GA4982@hertz.marvell.com>
	 <1308748326.29571.6.camel@jlt3.sipsolutions.net>
	 <4E045317.4040208@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Jun 2011 15:07:07 +0200
Message-ID: <1309007227.4317.0.camel@jlt3.sipsolutions.net> (sfid-20110625_150722_768653_54BB7B97)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-06-24 at 14:34 +0530, yogeshp wrote:

>  Andreas has tested the current implementation on his setup and haven't
> seen any WARN_ONs being hit. Should I send the final patch? 

Yeah, sure, thanks everyone. I'll ask around about the memory barrier
things independently.

johannes

