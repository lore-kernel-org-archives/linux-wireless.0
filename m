Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:42694 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753026AbXEZT5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 15:57:50 -0400
Message-ID: <46589133.9010608@lwfinger.net>
Date: Sat, 26 May 2007 14:57:39 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Uwe Bugla <uwe.bugla@gmx.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
	Maximilian Engelhardt <maxi@daemonizer.de>,
	linux-wireless@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
References: <20070524195616.234280@gmx.net> <200705262003.17403.mb@bu3sch.de> <20070526111934.e4650b6f.akpm@linux-foundation.org> <200705262138.05501.uwe.bugla@gmx.de>
In-Reply-To: <200705262138.05501.uwe.bugla@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Uwe Bugla wrote:
> 
> OK, applied this one against 2.6.22-rc3, assuming a typo error by you, Andrew.
> 
> Result is: No change: non functionable b44 device!

Could you please send the following:

1. the output of lsmod from the non-functioning kernel

2. the output of dmesg from the non-functioning kernel

3. your .config used to create your non-functioning kernel.

Thanks,

Larry

