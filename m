Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:60693 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbZACTh5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 14:37:57 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LJCJn-00062n-G2
	for linux-wireless@vger.kernel.org; Sat, 03 Jan 2009 19:37:55 +0000
Received: from 77.21.169.220 ([77.21.169.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 03 Jan 2009 19:37:55 +0000
Received: from feldmann_markus by 77.21.169.220 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 03 Jan 2009 19:37:55 +0000
To: linux-wireless@vger.kernel.org
From: feldmaus <feldmann_markus@gmx.de>
Subject: Re: Do not get BCM4303 to work
Date: Sat, 03 Jan 2009 20:39:14 +0100
Message-ID: <gjoeqa$7qq$1@ger.gmane.org> (sfid-20090103_203801_098568_5883C229)
References: <ga2fra$9q$1@ger.gmane.org> <gjob72$t2j$1@ger.gmane.org> <495FB6DD.1060807@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <495FB6DD.1060807@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger schrieb:
> Your log does not indicate that you pressed the button to turn the
> wifi on. All we see is that the hardware switch was off.
You are right. I pressed the Hardware wlan Button, but the LED Light
does not change. And the program <acpi_listen> does not show that
any acpi signal is sended.

I am not sure whether i can watch this signals with <acpi_listen>.

> 
> Is your radio on/off button one that generates a keycode, or does it
> need the WMI magic to be detected? If you are running X, then switch
> away by CTRL/ALT/F1 and log in. Use the showkey command and press the
> radio on/off switch. If it shows a scan code, report it back here. You
> get back to X with CTRL/ALT/F7.
Ok i tried <showkey> during pressing my hardware butto in a VT,
but this shows nothing.
I have "hp Extras" as modul. Other buttons on my Laptop are working.

I can activate/deactivate the wlan led by using the netwotkmanager
applet <nm-applet> under gnome.

What is WMI Magic ?

Regards Markus

