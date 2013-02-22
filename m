Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:15559 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab3BVPME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 10:12:04 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <drwho@infidigm.net>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>,
	<mohammed@qca.qualcomm.com>
Subject: Re: ath6kl: AR6004 missing firmware
References: <a846efff4d70649a69966a63a24fba37.squirrel@www.infidigm.net>
Date: Fri, 22 Feb 2013 17:11:57 +0200
In-Reply-To: <a846efff4d70649a69966a63a24fba37.squirrel@www.infidigm.net>
	(drwho@infidigm.net's message of "Thu, 21 Feb 2013 16:36:11 -0500")
Message-ID: <87ip5kqt6q.fsf@kamboji.qca.qualcomm.com> (sfid-20130222_161210_005551_7062CC9F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<drwho@infidigm.net> writes:

> Hello,
>
> I have an AR6004 hw1.1 usb.  The ath6kl driver is looking for its firmware
> in ath6k/AR6004/hw1.1.  Pulling from
>
> git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
>
> today only has firmware for hw1.2 and hw1.3.  I also have an AR6004 hw1.3
> usb and it is working fairly well with the same kernel I've built from
> Kalle Valo git.  I'm assuming hw1.1 is newer?

hw1.1 is actually much older than hw1.2 or hw1.3. I was even told that
hw1.1 shouldn't be publically available and that's why we haven't
released the firmware image for hw1.1. It's better that you use hw1.3
and forget hw1.1.

-- 
Kalle Valo
