Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:47311 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbZIEOTY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Sep 2009 10:19:24 -0400
Received: by fxm17 with SMTP id 17so1203018fxm.37
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2009 07:19:25 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 5 Sep 2009 10:11:33 -0400
Message-ID: <c4d76b3b0909050711o5f423115qaf1e5c80fded024d@mail.gmail.com>
Subject: at76c50x-usb Broken was: [PATCH] mac80211: allow configure_filter
	callback to sleep
From: Jason Andryuk <jandryuk@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2009 at 10:24 AM, Kalle Valo<kalle.valo@iki.fi> wrote:
> BTW, at76c50x-usb is broken currently. The change of providing bssid to
> the driver only after association broke it. I don't have time to fix it
> right now, but I try to find some time next week.

Do you know the commit that broke at76c50x-usb?  Was it "mac80211:
unify config_interface and bss_info_changed" or something else?

Thanks,

Jason
