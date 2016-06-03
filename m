Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33991 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbcFCR0T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 13:26:19 -0400
Received: by mail-oi0-f47.google.com with SMTP id e72so137323489oib.1
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2016 10:26:19 -0700 (PDT)
MIME-Version: 1.0
From: bruce m beach <brucembeach@gmail.com>
Date: Fri, 3 Jun 2016 10:26:18 -0700
Message-ID: <CAArymCnfQaa29D2EXGzwOrp0yvXES+Qq1X-HbSUxC6gig8pH_A@mail.gmail.com> (sfid-20160603_192624_483637_C98A5241)
Subject: ath9k_htc firmware
To: linux-wireless@vger.kernel.org
Cc: ath9k_htc_fw@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello All

 I am still working on cleaning up ath9k_htc firmware build tree for about 6
months now ( and looks like I'll be doing this for all eternity**2 ) and am
not clear myself what I'm looking for right now.

I'm looking for some kind of simple request in the ath9k_htc driver, through
the usb ep0, like a memory read on the card, where a urb is sent with
the resulting chain of events. The simpler the better. The simplest.

Bruce
