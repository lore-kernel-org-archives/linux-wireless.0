Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42318 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab1G3SiL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 14:38:11 -0400
Received: by iyb12 with SMTP id 12so5281231iyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jul 2011 11:38:10 -0700 (PDT)
Message-ID: <4E344F90.4040003@lwfinger.net> (sfid-20110730_203814_522167_AE8CB39E)
Date: Sat, 30 Jul 2011 13:38:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Laurence Darby <ldarby@tuffmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: I'm confused and angry
References: <20110730181433.50bd32db.ldarby@tuffmail.com>	<4E3442ED.90206@lwfinger.net> <20110730191422.3b2931ba.ldarby@tuffmail.com>
In-Reply-To: <20110730191422.3b2931ba.ldarby@tuffmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/30/2011 01:14 PM, Laurence Darby wrote:
>
> I have now enabled rfkill.  The hostapd error message is now:
>
> Hardware does not support configured mode
> wlan0: IEEE 802.11 Hardware does not support configured mode (2)
> Could not select hw_mode and channel. (-2)
> wlan0: Unable to setup interface.
> rmdir[ctrl_interface]: No such file or directory

Please post your hostapd.conf. I don't have any ath9k hardware and cannot check 
that it works with, but other wireless devices work with

interface=wlan0
driver=nl80211
hw_mode=g
channel=1
ssid=test2
#wpa=2
#wpa_key_mgmt=WPA-PSK
#wpa_pairwise=CCMP
#wpa_passphrase="deleted"

Larry
