Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38875 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab2BHCOf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 21:14:35 -0500
Received: by wgbdt10 with SMTP id dt10so79321wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 18:14:34 -0800 (PST)
Message-ID: <1328667237.1747.26.camel@localhost.localdomain> (sfid-20120208_031439_025876_DE49B16A)
Subject: [iwlwifi 5000] Linux 3.3.0-rc2 drops wifi connection (regression
 from 3.2) - "No buffer space available"
From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
To: linux-wireless@vger.kernel.org
Date: Wed, 08 Feb 2012 02:13:57 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Linux 3.3.0 drops connections from WiFi on 3.3 (worked on 3.2).
If I try to ping anything:

ping: sendmsg: No buffer space available

When I disable/enable WiFi by rfkill it works ok. I haven't found what
determines the period before it happens.

Best regards

