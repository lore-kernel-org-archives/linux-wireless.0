Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:48836 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab3KDORq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 09:17:46 -0500
Received: by mail-bk0-f51.google.com with SMTP id my12so1104043bkb.10
        for <linux-wireless@vger.kernel.org>; Mon, 04 Nov 2013 06:17:45 -0800 (PST)
Message-ID: <5277AC85.5050104@gmail.com> (sfid-20131104_151755_644672_48AB42A5)
Date: Mon, 04 Nov 2013 15:17:41 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	alexandre.f.demers@gmail.com, linville@tuxdriver.com
Subject: Re: r92su: status and will it be merged anytime soon?
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:

> The issue with r92su is: The driver is ready, but it's fundamentally
                                      ^^^^^^^^
> incompatible with the rtlwifi framework and mac80211.

_anything_ is better than a staging driver.

There are distributions that don't build staging drivers.

So, please, replace and delete staging/rtl8712 with r92su.

thank you.
