Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:64440 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753487AbYHJUwg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2008 16:52:36 -0400
Message-ID: <489F5508.2020808@lwfinger.net> (sfid-20080810_225240_946240_02F94B51)
Date: Sun, 10 Aug 2008 15:52:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problems with Belkin F5D7010 PCMCIA 1799:701f while trying WPA
 connection
References: <489EAA04.8070203@au-79.de> <489EF765.8050000@lwfinger.net> <489F501C.5070408@au-79.de>
In-Reply-To: <489F501C.5070408@au-79.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Robert Goldner wrote:
> 
> The ifconfig output seems good (like other working wlan cards), and the 
> interface is up. But iwlist wlan0 scan does not find any wlan-network. 
> Very strange, because I made this test very close to the access-point 
> (about 30 cm distance). With other wlan-cards I get signal levels of 
> ~80% of maximum. So maybe the receiving part is broken. I can not test 
> the hardware with the windows-driver, because I don't have a 
> windows-installation.

Just for the record, you should run iwlist as root. That is the only
way you will get an active scan. In addition, it may take several
tries; however, wpa_supplicant did all that before without finding any
results. A broken card is a strong possibility. Do any of your
colleagues have Windows?

Larry


