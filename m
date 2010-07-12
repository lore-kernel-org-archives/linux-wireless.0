Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63823 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab0GLTOx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jul 2010 15:14:53 -0400
Received: by bwz1 with SMTP id 1so2552501bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jul 2010 12:14:51 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: Rate control & USB
Date: Mon, 12 Jul 2010 21:14:09 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
References: <AANLkTinubmjYu9FyDU0B81F0gHmFPLnDUWYGmZ9Rodss@mail.gmail.com>
In-Reply-To: <AANLkTinubmjYu9FyDU0B81F0gHmFPLnDUWYGmZ9Rodss@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201007122114.09571.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag 12 Juli 2010 schrieb Ivo Van Doorn:
> I am currently looking into the old problem of the mac80211 rate
> control algorithms
> and USB devices. The Ralink USB devices (and as far as I know, the
> other USB devices
> as well), do not work well with the PID and Minstrel algorithms. This
> is caused by the
> fact that USB devices do not report the TX status to mac80211.

Ivo, do you know by any chance if the USB devices also have a TX_STA_FIFO
register like the PCI variants? Does it contain useful data or just crap?

Helmut
