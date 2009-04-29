Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:62832 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZD2UP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 16:15:27 -0400
Received: by fxm2 with SMTP id 2so1416280fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2009 13:15:26 -0700 (PDT)
Subject: [BUG] Connection fails after few minutes (iwl3945)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 23:15:21 +0300
Message-Id: <1241036121.9017.5.camel@maxim-laptop> (sfid-20090429_221531_809530_6073C29C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I usually use iwlwifi-git as my main kernel.

I have just pulled (actually I did that yesterday, but nothing changed
meanwhile), and now wireless ceases to work after few minutes.
(reassociation helps for another few minutes)

I'll bisect this.

I noticed that 'iw dev  wlan0 station dump' reports large inactive
times, but tx/rx continues to increase.

Only change in configuration, was that I disabled rfkill support.

Last known working version was around 2.6.30-rc2.

Best regards,
	Maxim Levitsky

