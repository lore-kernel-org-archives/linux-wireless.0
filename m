Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:56047 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbbKKANn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 19:13:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/20] staging/wilc1000: add struct net_device declaration
Date: Wed, 11 Nov 2015 01:13:33 +0100
Message-ID: <4397901.37Xo7LRaFs@wuerfel> (sfid-20151111_011402_491497_E6484583)
In-Reply-To: <20151111000248.GA5062@kroah.com>
References: <1447198960-2760143-1-git-send-email-arnd@arndb.de> <1447198960-2760143-2-git-send-email-arnd@arndb.de> <20151111000248.GA5062@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 10 November 2015 16:02:48 Greg Kroah-Hartman wrote:
> On Wed, Nov 11, 2015 at 12:42:21AM +0100, Arnd Bergmann wrote:
> I think this is already fixed in my staging-testing branch, right?

Ah right. I only got it with some rare randconfig builds, and assumed
the problem was still there because I did not see a patch that fixed
it. However, the config that originally failed is now fine, so it's
probably fixed.

The other patches won't apply cleanly without this one unfortunately.
Let me know if I should re-send them without this patch, as I don't
want to spam everyone unnecessarily.

You can also find my patches (now rebased with patch 1 dropped) in

git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git wilc1000

if that helps.

	Arnd
