Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:41245 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754681AbZAIS3a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 13:29:30 -0500
Message-ID: <49679783.8070901@lwfinger.net> (sfid-20090109_192936_743767_652CF326)
Date: Fri, 09 Jan 2009 12:29:23 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: feldmaus <feldmann_markus@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: show WMI magic Signals and activate hardware RF-kill button
References: <gk83fe$fu2$1@ger.gmane.org>
In-Reply-To: <gk83fe$fu2$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

feldmaus wrote:
> Hi All,
> 
> my wlan Button, which should enable/disable my wlan card,
> seems not to send signals which i can watch with <showkey>.
> 
> Larry Finger asked me:
> "Is your radio on/off button one that generates a keycode, or does it
> need the WMI magic to be detected?"
> 
> I need to get my wlan Button(hardware Rf-kill Button)
> to work to still turn my wlan physically on.
> 
> What is WMI Magic and are there Linux commands to watch
> was is going on?

There is a protocol named WMI for Windows Management Interface. I
assume that it was invented by the folks in Redmond. In any case, it
is designed to handle events that have buttons that do not generate a
keycode. The module named hp-wmi is supposed to take care of the
things under Linux for HP and Compaq computers.

Did you generate this module? Is it loaded?

I dont use this module on my HP as my RFKILL switch generates a
keycode. Others may be able to help you with it.

Larry
