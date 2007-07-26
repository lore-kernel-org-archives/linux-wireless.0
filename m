Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:59231 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932365AbXGZSUy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 14:20:54 -0400
Message-ID: <46A8E602.9090406@warmcat.com>
Date: Thu, 26 Jul 2007 19:20:50 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: revert some GFP_ATOMIC -> GFP_KERNEL changes
References: <200707261053.44771.flamingice@sourmilk.net>
In-Reply-To: <200707261053.44771.flamingice@sourmilk.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

> Some of the allocations made with GFP_ATOMIC really were necessary.

I tested it: this makes the BUG stuff in dmesg go away, thanks :-)

-Andy
