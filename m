Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f170.google.com ([74.125.82.170]:47529 "EHLO
        mail-ot0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752445AbdKMUWx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 15:22:53 -0500
Received: by mail-ot0-f170.google.com with SMTP id s4so5534347ote.4
        for <linux-wireless@vger.kernel.org>; Mon, 13 Nov 2017 12:22:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMRc=Mf92X2t8wjmE+xkXrA0QKY06uFeXhMY-97Ka=_UxuQbjw@mail.gmail.com>
References: <CAMRc=Mf92X2t8wjmE+xkXrA0QKY06uFeXhMY-97Ka=_UxuQbjw@mail.gmail.com>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 13 Nov 2017 21:22:52 +0100
Message-ID: <CAMRc=Mf-4HnRXLxoiPrzZVjeCpfY5+Q2Ydmee0GkViejk8nzaQ@mail.gmail.com> (sfid-20171113_212417_276301_63842D19)
Subject: Fwd: linux v4.14 causes firmware iwlwifi errors on Lenovo Thinkpad T440s
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Forwarding here too as I messed up the address the last time.
--

Hi,

I noticed my wireless interface can't get up with linux v4.14 and the
kernel log is flooded with firmware errors:

iwlwifi 0000:03:00.0: Firmware error during reconfiguration - reprobe!
iwlwifi 0000:03:00.0: FW error in SYNC CMD DQA_ENABLE_CMD

and

ieee80211 phy63: Hardware restart was requested.

The wireless controller is: Intel Corporation Wireless 7260 (rev 83)
Firmware used is: iwlwifi-7260-17

Everything works fine with v4.13.12.

I didn't have time today to bisect for the offending commit. Full log
uploaded[1].

Best regards,
Bartosz Golaszewski

[1] https://pastebin.com/jksqxvS6
