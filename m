Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.211.175]:62522 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZIEQUb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Sep 2009 12:20:31 -0400
Received: by ywh5 with SMTP id 5so2307146ywh.4
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2009 09:20:33 -0700 (PDT)
Message-ID: <4AA28FC5.6030508@lwfinger.net>
Date: Sat, 05 Sep 2009 11:20:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	Albert Herranz <albert_herranz@yahoo.es>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>
Subject: Re: [PATCH 0/5] b43: Prepare driver for sleeping busses
References: <200909042247.37655.mb@bu3sch.de>
In-Reply-To: <200909042247.37655.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> This patchset is the first series to remove atomic sections
> from the b43 driver to allow running b43 on a slow bus like
> SDIO that needs to sleep for register accesses.

I have installed this patch set and find no problems. It compiles
correctly after each step is installed, which ensures proper
bisection. The code appears to work correctly.

I also tested the stand-alone version of interrupt threading without
problems.

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
