Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40062 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab1HAEtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2011 00:49:24 -0400
Received: by wyg8 with SMTP id 8so1300128wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 31 Jul 2011 21:49:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E344F90.4040003@lwfinger.net>
References: <20110730181433.50bd32db.ldarby@tuffmail.com>
	<4E3442ED.90206@lwfinger.net>
	<20110730191422.3b2931ba.ldarby@tuffmail.com>
	<4E344F90.4040003@lwfinger.net>
Date: Mon, 1 Aug 2011 10:19:22 +0530
Message-ID: <CAD2nsn3veEqQwB-fnWgMQVXF7zVm-2LTpZrTpfeDUMbDUtPoyA@mail.gmail.com> (sfid-20110801_064928_215191_AF6A84C1)
Subject: Re: I'm confused and angry
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Laurence Darby <ldarby@tuffmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 31, 2011 at 12:08 AM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> On 07/30/2011 01:14 PM, Laurence Darby wrote:
>>
>> I have now enabled rfkill.  The hostapd error message is now:
>>
>> Hardware does not support configured mode
>> wlan0: IEEE 802.11 Hardware does not support configured mode (2)
>> Could not select hw_mode and channel. (-2)
>> wlan0: Unable to setup interface.
>> rmdir[ctrl_interface]: No such file or directory

i think you may be trying in 'a' mode while the card supports only 'g'
mode. please post your hostapd.conf.
ath9k_htc does supports AP mode.

>
> Please post your hostapd.conf. I don't have any ath9k hardware and cannot
> check that it works with, but other wireless devices work with
>
> interface=wlan0
> driver=nl80211
> hw_mode=g
> channel=1
> ssid=test2
> #wpa=2
> #wpa_key_mgmt=WPA-PSK
> #wpa_pairwise=CCMP
> #wpa_passphrase="deleted"
>
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
