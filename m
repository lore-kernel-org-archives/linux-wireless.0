Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62538 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab1GKHmm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 03:42:42 -0400
Received: by qyk29 with SMTP id 29so1225735qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2011 00:42:41 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 11 Jul 2011 09:42:41 +0200
Message-ID: <CANXYrmArYjhfmJ9g6nVDXoAfSiJVFHWomGu7tuh7hkiozJReXA@mail.gmail.com> (sfid-20110711_094246_203385_CC6BC41A)
Subject: ath9k/mac80211 transmission and descriptors
From: =?ISO-8859-1?Q?Manuel_S=E1ez?= <manuelsaezr@gmail.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am trying to send a frame exactly SIFS after one DTIM. I've seen
that the PS broadcast traffic should make something similar. If I try
to follow the same procedure I get some DMA errors.  I would like to
understand much better all this things but I am not able to find more
information about the tx descriptors and how the tx works. Could
someone give me some advice on where to get more details?

Thank you,
Manuel
