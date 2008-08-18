Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:36322 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbYHRHAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 03:00:38 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1570285fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 18 Aug 2008 00:00:37 -0700 (PDT)
Message-ID: <48A91E12.1060901@gmail.com> (sfid-20080818_090049_528167_37BDA130)
Date: Mon, 18 Aug 2008 09:00:34 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Subject: ath5k text [Was: pull request: wireless-2.6 2008-08-17]
References: <20080817185605.GC30679@tuxdriver.com> <20080817.151251.204370966.davem@davemloft.net>
In-Reply-To: <20080817.151251.204370966.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/18/2008 12:12 AM, David Miller wrote:
> Their commit messages reference SHA IDs but do not give a commit
> header line text reference as well.
> 
>       ath5k: Don't fiddle with MSI on suspend/resume.

John, this is it (even if I don't understand the purpose):

ath5k: Don't fiddle with MSI on suspend/resume.

Commit 256b152b005e319f985f50f2a910a75ba0def74f (ath5k: don't enable
MSI, we cannot handle it yet) has removed msi support, but overlooked
the suspend/resume code. This patch completes msi removal.

I don't consider this patch copyrightable, and thus put it into the
public domain. The result is of course a base.c file dual-licensed under
3-clause-BSD and GPL.
