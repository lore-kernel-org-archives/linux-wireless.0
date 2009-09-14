Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:17923 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbZINW6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 18:58:17 -0400
Received: by qw-out-2122.google.com with SMTP id 9so1134649qwb.37
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 15:58:20 -0700 (PDT)
Message-ID: <4AAECA8A.1060200@lwfinger.net>
Date: Mon, 14 Sep 2009 17:58:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: Don't abuse wl->current_dev in the led work
References: <200909142322.09152.mb@bu3sch.de>
In-Reply-To: <200909142322.09152.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> Don't abuse wl->current_dev in the LED work for checking whether we're
> going down. Add an explicit variable.
> This fixes a crash on rmmod dereferencing the wl->current_dev NULL pointer
> in various other places of the driver.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

This patch does not apply. What other patches should I have beyond the
current state of wireless-testing?

Larry
