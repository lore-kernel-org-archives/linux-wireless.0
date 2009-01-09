Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:41626 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbZAISC3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 13:02:29 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LLLgj-0002PE-R3
	for linux-wireless@vger.kernel.org; Fri, 09 Jan 2009 18:02:29 +0000
Received: from 77.21.169.220 ([77.21.169.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 18:02:29 +0000
Received: from feldmann_markus by 77.21.169.220 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 18:02:29 +0000
To: linux-wireless@vger.kernel.org
From: feldmaus <feldmann_markus@gmx.de>
Subject: show WMI magic Signals and activate hardware RF-kill button
Date: Fri, 09 Jan 2009 19:04:01 +0100
Message-ID: <gk83fe$fu2$1@ger.gmane.org> (sfid-20090109_190234_755736_F11BA593)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

my wlan Button, which should enable/disable my wlan card,
seems not to send signals which i can watch with <showkey>.

Larry Finger asked me:
"Is your radio on/off button one that generates a keycode, or does it
need the WMI magic to be detected?"

I need to get my wlan Button(hardware Rf-kill Button)
to work to still turn my wlan physically on.

What is WMI Magic and are there Linux commands to watch
was is going on?

Regards Markus

