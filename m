Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:50021 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbZIOM1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 08:27:39 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1251768fge.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2009 05:27:42 -0700 (PDT)
Message-ID: <4AAF9649.4080409@lwfinger.net>
Date: Tue, 15 Sep 2009 08:27:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: Don't abuse wl->current_dev in the led work
References: <200909142322.09152.mb@bu3sch.de> <4AAECA8A.1060200@lwfinger.net> <200909151149.22565.mb@bu3sch.de>
In-Reply-To: <200909151149.22565.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Tuesday 15 September 2009 00:58:18 Larry Finger wrote:
>> Michael Buesch wrote:
>>> Don't abuse wl->current_dev in the LED work for checking whether we're
>>> going down. Add an explicit variable.
>>> This fixes a crash on rmmod dereferencing the wl->current_dev NULL pointer
>>> in various other places of the driver.
>>>
>>> Signed-off-by: Michael Buesch <mb@bu3sch.de>
>> This patch does not apply. What other patches should I have beyond the
>> current state of wireless-testing?
> 
> All patches that are currently queued up.

I found the ones I needed in my mailboxes.

The patch cured my problem. Thanks and ack.

Larry
