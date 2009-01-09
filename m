Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:56119 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbZAITvi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 14:51:38 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LLNOI-0007A1-42
	for linux-wireless@vger.kernel.org; Fri, 09 Jan 2009 19:51:34 +0000
Received: from 77.21.169.220 ([77.21.169.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 19:51:34 +0000
Received: from feldmann_markus by 77.21.169.220 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 19:51:34 +0000
To: linux-wireless@vger.kernel.org
From: feldmaus <feldmann_markus@gmx.de>
Subject: Re: show WMI magic Signals and activate hardware RF-kill button
Date: Fri, 09 Jan 2009 20:52:31 +0100
Message-ID: <gk89qs$mra$1@ger.gmane.org> (sfid-20090109_205142_510153_C2B1F277)
References: <gk83fe$fu2$1@ger.gmane.org> <49679783.8070901@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <49679783.8070901@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger schrieb:
> 
> There is a protocol named WMI for Windows Management Interface. I
> assume that it was invented by the folks in Redmond. In any case, it
> is designed to handle events that have buttons that do not generate a
> keycode. The module named hp-wmi is supposed to take care of the
> things under Linux for HP and Compaq computers.
> 
> Did you generate this module? Is it loaded?
By now, yes.
hp_wmi                  4632  0
rfkill                  9648  4 rfkill_input,hp_wmi,b43legacy
wmi                     6568  1 hp_wmi

But i still do not get any keycode with <showkey>.
Is there an other program than <showkey> ?

Where i can solve this problem with the wmi code ?

Regards Markus

