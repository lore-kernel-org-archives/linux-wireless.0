Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:53721 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592AbXHYA1X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 20:27:23 -0400
Date: Sat, 25 Aug 2007 02:27:22 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1: net/wireless/rt2x00mac.c build failure
Message-ID: <20070825002722.GA5449@deine-taler.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <200708222116.22386.m.kozlowski@tuxland.pl> <200708222131.24882.IvDoorn@gmail.com> <20070822195814.GG2926@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070822195814.GG2926@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:

> Andrew had a lot of problems working-out conflicts between wireless-dev
> and net-2.6.24.  I have since taken steps to help with this, but I
> think his pull was from before the wireless-dev rebase.  Hopefully the
> next -mm will be better.

John,

just for notice since the reorganization the zd1211rw-mac80211
driver doesn't work anymore. Station mode used to work stable with
WPA, but now the system freezes.

I will try to fix it, but it looks like that it will take a fairly
large amount of work.

Kind regards,

Ulrich

-- 
Uli Kunitz
