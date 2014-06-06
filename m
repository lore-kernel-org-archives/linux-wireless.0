Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:36586 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbaFFPTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 11:19:44 -0400
Received: by mail-la0-f45.google.com with SMTP id s18so1630547lam.4
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jun 2014 08:19:42 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 6 Jun 2014 08:19:42 -0700
Message-ID: <CAF1ivSbNu=TQRf653aoKJ2rNbhktOBnKzRboUn59xkCYD9KyYw@mail.gmail.com> (sfid-20140606_171947_276442_5866EA2B)
Subject: wifi p2p question
From: Lin Ming <minggr@gmail.com>
To: johannes.berg@intel.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I'm going to try wifi p2p on 2 laptops with latest kernel and wpa_supplicant.

Does wfi p2p only need software(driver/wpa_supplicant) support?
Or does it need some specific wifi hardware/firmware/microcode support?

>From wiki http://wireless.kernel.org/en/developers/p2p/howto:
(OR another device that has a mac80211 driver, but these are known to
work, iwlwifi does notcurrently work with any released microcode)

It looks like, in theory, all wifi hardware with a mac80211 driver should work.
Is my understanding correct?

Thanks,
Ming
