Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:33346 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbdBUJU1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 04:20:27 -0500
Received: by mail-qk0-f180.google.com with SMTP id p22so116658623qka.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 01:20:27 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Avery Pennarun <apenwarr@gmail.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Subject: wpa psk offloading
Message-ID: <11aeb0b3-5c44-32d5-c73a-c809f3d53c9f@broadcom.com> (sfid-20170221_102031_441573_6B97A86B)
Date: Tue, 21 Feb 2017 10:20:24 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Internally I am asked to look at "pmk plumbing" patches allowing
firmware to deal with 4-way handshake. Now I noticed this topic being
discussed during last wireless workshop in Santa Fe [1].

I do not recall any follow-up after that. At least no concrete patches,
right? Also in wpa_supplicant there is already a solution using QCA
vendor command. Should we aim to adopt just that or are there
issues/requirements not covered by that.

Regards,
Arend

[1]
https://docs.google.com/document/u/1/d/e/2PACX-1vQXbVQ-3zQt3Bcr3OWfwzbw_C49tTvf0ed8Hmf7b20E6tXc3a40tWZmPku49iGDE-OhgxNmO_lkkHEn/pub#h.kj1rq2w7lxdv
