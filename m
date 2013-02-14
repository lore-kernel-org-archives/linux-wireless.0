Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hetz2.bluebottle.com ([176.9.57.138]:49809 "EHLO
	fe0.bluebottle.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758971Ab3BNUlq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 15:41:46 -0500
Date: Thu, 14 Feb 2013 21:35:53 +0100
From: Bastian Bittorf <bittorf@bluebottle.com>
To: openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org
Subject: Re: WRT54g / b43 / mac802.11 BREAKTHROUGH
Message-ID: <20130214203553.GA27934@medion.lan> (sfid-20130214_214152_580175_700956AA)
References: <1342612598.5006a476022c6@mail.bluebottle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1342612598.5006a476022c6@mail.bluebottle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Bastian Bittorf <bittorf@bluebottle.com> [18.07.2012 17:43]:
> hi devs!
> 
> yesterday we had a breaktrough debugging b43 in our hackspace maschinenraum/m18[1,2]
> at weimar.freifunk.net[3,4] - since a long time our darling wrt54g suffers from a
> hanging wifi and bad performance[5], but the workaround is easy: now it's up to
> you to fix the rootcause.

[...]

another issues was found, see https://dev.openwrt.org/ticket/7552#comment:69

"...under high load and have found that probably some of the silent freezes
are due to overflow of the RX DMA buffer, seems like b43 does not
handlre such a situation at all."

https://dev.openwrt.org/attachment/ticket/7552/840-b43-workaround-rx-fifo-overflow.patch

the patch is working so far, but is only a workaround.
has somebody a better code-idea?

bye, bastian
