Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36855 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbcFIPOT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 11:14:19 -0400
Received: by mail-oi0-f67.google.com with SMTP id d132so7997504oig.3
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jun 2016 08:14:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57533996.905@rempel-privat.de>
References: <CAArymCnfQaa29D2EXGzwOrp0yvXES+Qq1X-HbSUxC6gig8pH_A@mail.gmail.com>
 <57526D1D.9000305@gmx.net> <CAArymCm7SgKyK_cy+MucMb5-8nDZshiOCu-mPVyKR6WnNCm5Lg@mail.gmail.com>
 <57533996.905@rempel-privat.de>
From: bruce m beach <brucembeach@gmail.com>
Date: Thu, 9 Jun 2016 08:14:18 -0700
Message-ID: <CAArymCkZMc4Z8aqNMTttPEdLu356BHg754tww2b0xFw1fDSmHg@mail.gmail.com> (sfid-20160609_171425_534264_73F67F41)
Subject: ath9k_htc firmware
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@lists.ath9k.org, ath9k_htc_fw@lists.infradead.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Here is one example how you can add new command to firmware:
> https://github.com/olerem/open-ath9k-htc-firmware/commit
>> /c73c159303e30a28e2d3dc05ba0d2d15504e5fad

Thanks for the example. Seems clear as to how it works. Currently I'm looking
at anything to do with these tables, which I'll be at it for the next month or
so. Going back to the original question I see that the reason that I didn't
find very much in terms of traffic on EP0 is that there isn't very
much traffic on
 EP0 so that answers that.

Currently the real problem that I'm having is that I can't open a USBLIB FD out
in userland while the kernel driver is attached. I can talk to the stick
without the driver but while the driver is attached it blocks the access and I
would very much like to disable that block.

Bruce
