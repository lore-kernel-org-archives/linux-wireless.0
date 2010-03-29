Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43802 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab0C2RPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 13:15:13 -0400
Date: Mon, 29 Mar 2010 13:06:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ralph Benzinger <t1@endlos.net>
Cc: linux-wireless@vger.kernel.org, malattia@linux.it,
	platform-driver-x86@vger.kernel.org
Subject: Re: Problems with hardware radio kill switch on Sony Vaio notebook
Message-ID: <20100329170604.GC4984@tuxdriver.com>
References: <20100329152721.GC6445@endlos.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100329152721.GC6445@endlos.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 29, 2010 at 05:27:21PM +0200, Ralph Benzinger wrote:

> My Sony Vaio VPC-Y11S1E notebook has an Atheros AR9285 chip, which is
> supported just fine by ath9k.  The notebook also has a physical radio
> kill switch at the front that can be slid into one of two positions.
> Alas, the rfkill tool shows wlan0 as "hard blocked: yes" for either
> switch position.  Consequently, txpower is off, and wireless
> networking cannot be activated.
> 
> Could you kindly indicate which part of the kernel would be
> responsible for handling the radio kill switches -- cfg80211, ath9k,
> sony-laptop, ...?  Are there any known fixes or workarounds?  I'm
> using Kubuntu 9.10 with their stock kernel 2.6.31 and the wireless
> backports modules right now, but tests with Kubuntu 10.4 Beta and
> 2.6.32 failed as well.

Generally, sony-laptop would be responsible for correctly reporting
the rfkill switch state.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
