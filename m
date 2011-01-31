Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:42525 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab1AaW6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 17:58:04 -0500
Message-ID: <4D473E72.3050307@davizone.at>
Date: Mon, 31 Jan 2011 23:57:54 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 00/18] wl1251: feature ports / monitor mode / packet injection
References: <4D45A583.3060605@davizone.at> <4D45B7B2.40001@davizone.at> <87r5btdsb8.fsf@purkki.adurom.net>
In-Reply-To: <87r5btdsb8.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 2011-01-31 16:08, schrieb Kalle Valo:
> How did you test the patches? For example, what hardware did you use
> etc.

I tested the patches with compat-wireless and a modified fremantle 2.6.28 kernel
on my Nokia N900.

> About the code from fremantle kernels. Few weeks ago nokia sent me
> privately the original patches from their internal git tree, I gave
> some comments and never heard back. So, in theory I should have all
> the fremantle patches somewhere in my email archives. I would just
> need to clean them up and send them here. I'll go over your patches
> and let's see what we should do.

It would be interesting if I missed some features. I diffed the drivers, but I
am not 100% sure if I overlooked something useful.
One thing I haven't included in this patchset is the netlink interface from the
fremantle code for NVS loading because I thought it wouldn't be accepted anyway.
