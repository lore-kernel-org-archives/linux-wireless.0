Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:38154 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbYKIPRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 10:17:04 -0500
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Cc: "David Shwatrz" <dshwatrz@gmail.com>, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: Where is allow-ap-vlan-modes.patch ?
References: <31436f4a0811090701r4676409er8f53a32c91bc3ced@mail.gmail.com>
	<200811091604.43705.IvDoorn@gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sun, 09 Nov 2008 17:16:35 +0200
In-Reply-To: <200811091604.43705.IvDoorn@gmail.com> (ext Ivo van Doorn's message of "Sun\, 9 Nov 2008 16\:04\:43 +0100")
Message-ID: <874p2h2alo.fsf@nokia.com> (sfid-20081109_161709_624849_AD3593E7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn <ivdoorn@gmail.com> writes:

>> I have a question:
>> Why was the allow-ap-vlan-modes.patch removed from
>> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/?
>> 
>> I see that it was there until recently (to be accurate,
>> 30.10.08 was the last time it was there).
>> 
>> I do not see that it was applied; I have the latest git tree of
>> wireless-2.6 and wireless-next-2.6
>
> It is currently present in the wireless-testing git tree.

Yes, I can verify that. I have AP mode working in b43 using latest
hostapd from git and wireless-testing.

-- 
Kalle Valo
