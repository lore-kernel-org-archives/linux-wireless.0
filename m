Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53457 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab0HQRhX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 13:37:23 -0400
Received: by ewy23 with SMTP id 23so3195365ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Aug 2010 10:37:22 -0700 (PDT)
MIME-Version: 1.0
From: Michael Griepentrog <michael.griepentrog@gmail.com>
Date: Tue, 17 Aug 2010 12:37:01 -0500
Message-ID: <AANLkTi=axa4jxYCodm4mhedtnauPzr5AJvD5Z2GssWdc@mail.gmail.com>
Subject: [mac80211] minstrel_ht rate population
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm looking at minstrel_ht_get_rate() from the latest git, and I
noticed that the rates are getting set into info->status.rates. Is
this correct? My impression was that array gets populated by the
driver after a successful transmission. ath9k's rate control algorithm
uses the expected tx_info->control.rates. Minstrel_ht appears to still
work, am I missing something?

Thanks,
Michael Griepentrog
