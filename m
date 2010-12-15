Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:59363 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab0LOQS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 11:18:26 -0500
Received: by fxm18 with SMTP id 18so2224069fxm.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 08:18:24 -0800 (PST)
Message-ID: <4D08EA6D.6070106@lwfinger.net>
Date: Wed, 15 Dec 2010 10:18:53 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/22] rtl8192ce: Initial upload of driver
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

What is the status of the driver that was submitted in this patch set? There has
been no ACK, but on the other hand, neither the RFC nor the PATCH set got any
negative or positive comments. These devices are in the wild and several users
on the openSUSE forum have needed help is setting up the vendor driver on which
this one is based.

If you prefer that it go to staging first, I will send it to GregKH, but since
it uses mac80211, I think it is ready for wireless.

Thanks,

Larry
