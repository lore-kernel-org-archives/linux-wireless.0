Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:52920 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaEYRYE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 May 2014 13:24:04 -0400
Received: by mail-ve0-f172.google.com with SMTP id oz11so8336491veb.17
        for <linux-wireless@vger.kernel.org>; Sun, 25 May 2014 10:24:03 -0700 (PDT)
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 25 May 2014 10:23:42 -0700
Message-ID: <CALCETrUffJLp+AM2-13HEE5+cKtyMMSjJFsJnhcd5kMzebs3NA@mail.gmail.com> (sfid-20140525_192520_959843_AA87DCA2)
Subject: Help debugging iwldvm / ath10k stalls
To: Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have an old iwldvm station (Intel(R) Centrino(R) Ultimate-N 6300
AGN, REV=0x74) and a new ath10k AP (QCA9880-BR4A, I think, as found in
the TP-Link Archer C7 vs).  The former is Fedora's 3.14 kernel and the
latter is OpenWRT trunk from a few days ago.

Every now and then, my connection drops out.  From wireshark on the
station, it looks like traffic from the AP to the STA is coming
through but traffic from the STA to the AP is not.  I could be wrong
here, though.  Nothing is logged in either machine's kernel log.
After 5 seconds to a couple minutes, everything starts working again.

A couple of Apple devices using the same radio on the same AP seem to work fine.

Any advice for debugging this?  I don't know where to start.

Thanks,
Andy
