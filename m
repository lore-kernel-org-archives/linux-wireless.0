Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33879 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933298Ab2HVU4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 16:56:55 -0400
Received: by qcro28 with SMTP id o28so27616qcr.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Aug 2012 13:56:54 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 22 Aug 2012 13:56:54 -0700
Message-ID: <CAE3CJbmsAnRKCeOjtTk9TXH4zc6UtadCmkdwMT4rnFrDR8UVtg@mail.gmail.com> (sfid-20120822_225659_517489_9C3DAC8C)
Subject: Question about ath9k/mac80211 Driver
From: Patrick Connolly <pjc999@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
      I'm new to ath9k and in need of some basic/rudimentary help.
      I'm working with an Access Point that uses the ath9k/mac80211
driver combination to talk to an Atheros AR9285.  The firmware is
OpenWrt.

    What is the best command line tool to use to get the driver to
switch the chip's mode between 'b', 'g', or 'bg' (mixed) mode?  The
OpenWrt Tools we're currently using ("uci" "wifi") are not talking to
the driver at all and when we switch settings (between b,g,bg), the
beacons go out advertising the same rates regardless of the mode.

    Any help would be appreciated.

-Patrick
