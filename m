Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:36032 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbcCIUWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 15:22:47 -0500
Received: by mail-oi0-f48.google.com with SMTP id r187so44778463oih.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2016 12:22:47 -0800 (PST)
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>, dan.g.tob@gmail.com
From: Larry Finger <Larry.Finger@lwfinger.net>
Subject: New firmware for RT2870
Message-ID: <56E08615.9060208@lwfinger.net> (sfid-20160309_212251_332705_FB97E598)
Date: Wed, 9 Mar 2016 14:22:45 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In https://bugzilla.kernel.org/show_bug.cgi?id=114151, the OP reports improved 
stability and performance for an RT5370 using a newer firmware that came with 
the driver CD. The logs show this to be version 0.36, whereas the version now in 
linux-firmware is version 0.29.

I downloaded the firmware from b.k.o. It had very little effect on my no-name 
adapter with ID 148f:3070. It still gets ping losses of 10-15%.

Should this new version be submitted to linux-firmware? Its provenance seems to 
be sketchy, but submission would likely be legal.

Larry
