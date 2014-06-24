Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:52814 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaFXFrz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 01:47:55 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	<linux-wireless@vger.kernel.org>,
	<wireless-regdb@lists.infradead.org>
Subject: Re: [RFC] wireless:  improve dfs-region intersection.
References: <1402517314-20110-1-git-send-email-greearb@candelatech.com>
	<20140623191504.GD1390@garbanzo.do-not-panic.com>
	<53A89011.1010806@candelatech.com>
Date: Tue, 24 Jun 2014 08:47:46 +0300
In-Reply-To: <53A89011.1010806@candelatech.com> (Ben Greear's message of "Mon,
	23 Jun 2014 13:37:37 -0700")
Message-ID: <87pphy7ta5.fsf@kamboji.qca.qualcomm.com> (sfid-20140624_074758_459724_02367EA3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> As for being confusing, the current code is nasty and it is very hard
> to have any idea why things do or do not work, especially if you do not
> have ability to add printk all over the place to figure out what the
> code is actually doing.

Heh, this is exatly what I do when I debug regulatory issues :)

> I think some more effort should go into printing out a lot more
> information about the regulator domain decisions, through printk
> or related call if nothing better is found...

IMHO the regulatory code is the most fragile part of Linux wireless
stack and needs a rewrite. It needs to be simple and easy to understand.

-- 
Kalle Valo
