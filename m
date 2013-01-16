Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:44598 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab3APXFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 18:05:07 -0500
Received: by mail-vb0-f54.google.com with SMTP id l1so1902065vba.13
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jan 2013 15:05:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABPxzYJciFXV=S7BGWT_V-M8U9ydpiBT8RSJJn35oHQy+zh3aQ@mail.gmail.com>
References: <CABPxzYL1LM-XAAb1RomgcM=O9Ma=KJZcbmEgTA678FSFuT8QMg@mail.gmail.com>
	<1358248982.4648.1.camel@jlt4.sipsolutions.net>
	<CABPxzYJciFXV=S7BGWT_V-M8U9ydpiBT8RSJJn35oHQy+zh3aQ@mail.gmail.com>
Date: Wed, 16 Jan 2013 15:05:05 -0800
Message-ID: <CAJ-Vmon_m1bH_OTL7XitXwRvqPK2+Q-V7E=rcBdGw7Gkj58LJQ@mail.gmail.com> (sfid-20130117_000512_688423_1DB51540)
Subject: Re: Tx AMSDU Support
From: Adrian Chadd <adrian@freebsd.org>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. for testing that out, I ended up just using a NIC that implements
AMSDU in software.

God knows what it was though (intel?)..

Yes it would be nice to implement A-MSDU TX in software. But I agree
with Felix - there's a lot of logic that can be shared with the A-MPDU
aggregation code..


Adrian
