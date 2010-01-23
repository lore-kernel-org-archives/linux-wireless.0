Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:14916 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0AWIfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 03:35:13 -0500
Received: by ey-out-2122.google.com with SMTP id d26so491598eyd.19
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 00:35:12 -0800 (PST)
To: "Paul \"TBBle\" Hampson" <Paul.Hampson@Pobox.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: NULL dereference on wireless-testing/head
References: <297c1a111001222341gad6b26eh8a410a73a2d9a3dc@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 23 Jan 2010 10:35:09 +0200
In-Reply-To: <297c1a111001222341gad6b26eh8a410a73a2d9a3dc@mail.gmail.com> (Paul Hampson's message of "Sat\, 23 Jan 2010 18\:41\:30 +1100")
Message-ID: <87tyudp6bm.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Paul \"TBBle\" Hampson" <Paul.Hampson@Pobox.com> writes:

> I just upgraded my Alix.2+ath5k router box from 2.6.30-rc8 w/some
> random wireless-testing tree to wireless-testing/head (96ada3c) and
> started getting NULL pointer dereferences.
>
> git-bisect indicated 813d766 as the culprit, and reverting that commit
> on top of 96ada3c seems to be working.

[...]

> [ 1082.158061] EIP: [<d0ac1ec5>] invoke_tx_handlers+0x467/0xc27

There are patches from John and Johannes which should fix this. Latest
wireless-testing contains the patches.

-- 
Kalle Valo
