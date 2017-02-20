Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:34949 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750881AbdBTXXC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 18:23:02 -0500
Received: by mail-it0-f54.google.com with SMTP id 203so87618997ith.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Feb 2017 15:23:02 -0800 (PST)
MIME-Version: 1.0
From: "Thomas d'Otreppe" <tdotreppe@gmail.com>
Date: Mon, 20 Feb 2017 16:22:20 -0700
Message-ID: <CALs6+XLDZLmc6JWMPun4sT+W_M4Cqh47LcK+HjiuZ8gKFLkbTA@mail.gmail.com> (sfid-20170221_002306_313869_E4D6D4DA)
Subject: Monitor mode 'cook' flag meaning
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been looking through the different flags for monitor mode in iw.
Most of them are rather obvious (and well explained) but what is
exactly 'cooked mode'?

I looked up in Google and in the linux-wireless wiki (nothing in
there) and I only found explanations in 2 patches (most likely still
in the source code) which are still vague:
- A monitor interface in "cooked" mode will see all frames that
mac80211 has not used internally
- report frames after processing. Overrides all other flags.

Thinking about what the first one says, it doesn't seem any different
than just fcsfail. I don't even see when control or otherbss should be
needed since 'none' is already providing them.

Am I correct? Or is it related to transmitting frames? And in this case, how?

Thanks in advance,

Thomas
