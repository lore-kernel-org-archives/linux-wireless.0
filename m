Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:39497 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbaFJV7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 17:59:08 -0400
Received: by mail-la0-f45.google.com with SMTP id s18so4413469lam.32
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 14:59:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYK2xZwwQ4h+ifB6KP9wyr39RF2Z6zrsyZ=0CtC+YceRWQ@mail.gmail.com>
References: <CANy8jx+RY-_wbX5JqdF_xwyP+2XQ-V9Ae95Y5MOzd=fyir8KTw@mail.gmail.com>
 <CABPxzYK2xZwwQ4h+ifB6KP9wyr39RF2Z6zrsyZ=0CtC+YceRWQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 10 Jun 2014 14:58:47 -0700
Message-ID: <CAB=NE6XuAj8jEwLesbSDoyawWh0pWTD-w=L3Jrxx+630QSkm5w@mail.gmail.com> (sfid-20140610_235912_527321_6D7C0B73)
Subject: Re: max_erip/tx_power not being set correctly
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: John Walker <john@x109.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 25, 2014 at 10:55 AM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> https://dev.openwrt.org/browser/trunk/package/kernel/mac80211/patches/005-make-genregdb.awk-skip-antenna-gain.patch?rev=40296

This just ignores antenna gain as it was useless.

  Luis
