Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.iliad.fr ([212.27.33.1]:55106 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757890Ab3IBK0p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Sep 2013 06:26:45 -0400
Message-ID: <1378117603.22316.4.camel@sakura.staff.proxad.net> (sfid-20130902_122647_934218_9BFE3D8E)
Subject: Re: [PATCH] cfg80211: fix potential deadlock regression
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 02 Sep 2013 12:26:43 +0200
In-Reply-To: <1377865387.16256.15.camel@jlt4.sipsolutions.net>
References: <1370377370-23055-1-git-send-email-johannes@sipsolutions.net>
	 <1377719389.559.9.camel@sakura.staff.proxad.net>
	 <1377865387.16256.15.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 2013-08-30 at 14:23 +0200, Johannes Berg wrote:

> I think this should be OK:
> http://p.sipsolutions.net/28cf9ed446845440.txt, can you try?

Works for me

Thanks

-- 
Maxime


