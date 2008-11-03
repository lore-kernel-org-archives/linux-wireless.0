Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37390
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754852AbYKCHfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 02:35:53 -0500
Date: Sun, 02 Nov 2008 23:35:28 -0800 (PST)
Message-Id: <20081102.233528.91273615.davem@davemloft.net> (sfid-20081103_083618_184141_CCC72C0C)
To: johannes@sipsolutions.net
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org
Subject: Re: Alignment issue with 4965 and 2.6.28-rc3
From: David Miller <davem@davemloft.net>
In-Reply-To: <1225697100.3619.21.camel@johannes.berg>
References: <DFAA4A8C-F8D5-4D08-9C6E-8BB65E3BCFC2@holtmann.org>
	<1225697100.3619.21.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 03 Nov 2008 08:25:00 +0100

> I've tried sending a patch to add
> CONFIG_HAVE_EFFICIENT_ALIGNED_ACCESS or something like that so that
> we can fix it up if that is unset or make the driver depend on it,
> but it hasn't stuck so far, so for now, ignore the warning and don't
> try to use Intel wireless hw on platforms that don't like unaligned
> loads.

What are you smoking? ;-)

arch/Kconfig:config HAVE_EFFICIENT_UNALIGNED_ACCESS
arch/powerpc/Kconfig:	select HAVE_EFFICIENT_UNALIGNED_ACCESS
arch/x86/Kconfig:	select HAVE_EFFICIENT_UNALIGNED_ACCESS
