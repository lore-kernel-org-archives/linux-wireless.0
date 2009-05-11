Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:22041 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbZEKERs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 00:17:48 -0400
Message-ID: <20090511001749.efx510zpk404owww-cebfxv@webmail.spamcop.net>
Date: Mon, 11 May 2009 00:17:49 -0400
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Alexander Bartha <alex.xy.privat@gmx.at>,
	ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k module-Unable to set channel-since ath
	comes
References: <20090203173228.GB9713@tesla> <20090206202205.218710@gmx.net>
	<20090206211804.GG5031@tesla> <20090214230618.203560@gmx.net>
	<43e72e890902141718v544f5caejb71f53bdadbf8a8f@mail.gmail.com>
	<20090216205115.21860@gmx.net>
	<43e72e890902161342j23b68a4eoabddb047fb9d9084@mail.gmail.com>
	<20090508211237.316290@gmx.net> <1241818845.6240.4.camel@mj>
	<43e72e890905081453h2d660e6dl38b714467c8f24cb@mail.gmail.com>
	<43e72e890905101141r6fe3b655ta158acabf4c87ec3@mail.gmail.com>
In-Reply-To: <43e72e890905101141r6fe3b655ta158acabf4c87ec3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:

> I can reproduce, and I tried without the idle patches but I still see
> the issue. I see this issue only after suspend. Did you suspend and
> get this as well? I see this using AR5416. If you are seeing this on
> suspend can you try with the patch I posted to linux-wireless to see
> if it helps a little?

I saw this on AR9280 without any suspends.  The card doesn't support  
the 802.11a range, so it's not a direct equivalent of the problem I  
bisected with ath5k (invalid rates when scanning and transmitting).

-- 
Regards,
Pavel Roskin
