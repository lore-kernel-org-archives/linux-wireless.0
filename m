Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:53569 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758815Ab3BLNfn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 08:35:43 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Joe Perches <joe@perches.com>
Cc: Solomon Peachy <pizza@shaftnet.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 01/14] cw1200: v4: low-level hardware I/O functions
References: <1360355527-12159-1-git-send-email-pizza@shaftnet.org>
	<1360355527-12159-2-git-send-email-pizza@shaftnet.org>
	<1360372559.13487.14.camel@joe-AO722>
	<20130211185322.GB3123@shaftnet.org>
	<1360609295.2028.44.camel@joe-AO722>
Date: Tue, 12 Feb 2013 15:35:41 +0200
In-Reply-To: <1360609295.2028.44.camel@joe-AO722> (Joe Perches's message of
	"Mon, 11 Feb 2013 11:01:35 -0800")
Message-ID: <87vc9xac42.fsf@purkki.adurom.net> (sfid-20130212_143546_725212_EFBF180D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

>> Question -- as a matter of policy, is the goal to have a completely 
>> clean checkpatch run?  I get that there should be no ERRORs, but 
>> WARNINGs/CHECKs are not considered fatal for a reason, right?
>
> No.  It's just a guideline.  As far as I'm concerned,
> ignore every checkpatch message you don't agree with.

BTW, I think this is becoming a major problem. I have had discussions
with various people who consider checkpatch as some sort of automatic
upstream compliance system. I'm a bit worried about that. People should
consider just as a tool next to other tools, not as the holy bible.

Joe, when working with checkpatch documentation you could try to
emphasise that part (or it might be that you have already done that).

Just my 0.02 EUR.

-- 
Kalle Valo
