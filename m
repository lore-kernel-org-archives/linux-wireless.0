Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:53953 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbZKPENx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2009 23:13:53 -0500
Received: by ywh40 with SMTP id 40so2781920ywh.33
        for <linux-wireless@vger.kernel.org>; Sun, 15 Nov 2009 20:13:59 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 16 Nov 2009 09:43:58 +0530
Message-ID: <26b26d180911152013p22564134vf5cbd94d3bac7b@mail.gmail.com>
Subject: trying to add rfkill support to realtek driver for rtl8192e
From: saurav barik <saurav.barik@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am trying to implement rfkill support for realtek driver for rtl8192e.
The realtek driver we are using is very much similar to the one in
kernel 2.6.31.5(linux-2.6.31.5/drivers/staging/rtl8192su).
In order to use "wiphy_rfkill_set_hw_state", I need "struct wiphy"
which in turn is a part of "ieee80211_hw" structure.
However ieee80211_hw is not used in our driver.
Is the usage of 80211_hw is obsolete?
Without having the above structure how can I use the rfkill interface?

Anybody aware of this, please share some pointers.

Thanks for your time.

Regards,
Saurav
