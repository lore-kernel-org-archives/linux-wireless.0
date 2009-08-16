Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:58500 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbZHPQFf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2009 12:05:35 -0400
Received: by pzk34 with SMTP id 34so1615413pzk.4
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2009 09:05:36 -0700 (PDT)
Message-ID: <4A882E30.30009@lwfinger.net>
Date: Sun, 16 Aug 2009 11:05:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Mark Huijgen <mark@huijgen.tk>
Subject: Some success with LP PHY
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor,

I can report some success. This morning, I got input from a 'sudo
iwlist scan' command. It does not show all the nearby APs, including
mine on channel 1, but I see a couple on channel 6, and one on 11.

I'm having a problem with 2062 channel tune routine. It gets the "PLL
charge pump out of range" error. To get anything to work, I had to
replace the error return with a printk that prints the channel. The
error happens for channels 1-6 and 9-11. Perhaps the fact that it is
OK for channels 7 and 8 is a clue. If so, I don't understand it yet.

Thanks for your efforts. It is exciting to see this device finally
coming to life.

Larry
