Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36569 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbZKKEJJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 23:09:09 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 20:09:15 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19194.14704.375018.158963@gargle.gargle.HOWL>
Date: Wed, 11 Nov 2009 09:41:28 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Aeolus Yang <Aeolus.Yang@Atheros.com>
Subject: ath9k rate control - busted
In-Reply-To: <43e72e890911101640r69ad67c6l2e48250596c19d44@mail.gmail.com>
References: <43e72e890911101640r69ad67c6l2e48250596c19d44@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> One way or another I think we should prioritize making ath9k work with
> minstrel optionally on legacy networks at least for now, and see if we
> can help Felix test/advance minstrel support for MCS rate support.
> 
> The ath9k rate control code proves unmaintainable, not clearly
> understood even with things like this:
> 
> /* Update PER, RSSI and whatever else that the code thinks it is doing.
>    If you can make sense of all this, you really need to go out more. */

I'll send a patch removing this comment. :-)

Sujith
