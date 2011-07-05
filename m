Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61632 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab1GELok convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 07:44:40 -0400
Received: by wyg8 with SMTP id 8so3924539wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 04:44:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E12E9A3.2070004@googlemail.com>
References: <4E12E9A3.2070004@googlemail.com>
Date: Tue, 5 Jul 2011 17:14:39 +0530
Message-ID: <CAD2nsn1DCei1UZ9xRvj0ErwHN7VmAzBwJrK75EQmqz_w0wBEHQ@mail.gmail.com> (sfid-20110705_134443_957026_289225C5)
Subject: Re: [ath9k,hostapd]Connection broken after some time...
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Dennis Borgmann <dennis.borgmann@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 5, 2011 at 4:08 PM, Dennis Borgmann
<dennis.borgmann@googlemail.com> wrote:
> Hello!
>
> After asking several times on the IRC without getting any answer, I'll try
> to use this way of asking my question.
>
> I am using wpa_supplicant 0.7.3 and hostapd in version 0.7.3 with a very
> simple TKIP encryption on ath9k. After some time, the machine running
> wpa_supplicant still states after "iw dev wlan0 link", that it's still
> connected, the machine running hostapd states after "iw dev wlan0 station
> dump" that no device would be connected. I can't ping from either side.
> Sniffing on a third machine with a monitor card and wireshark shows
> deauthentication packets from the hostapd-machine after each frame sent by
> the wpa_supplicant machine. Given reason in the deauth-frames is "packet
> received from non-authenticated client".

please mention whether you are using latest-wireless testing or
compat-wireless(date).
also had a chance to try with 0.8.x hostapd/wpa_supplicant?

>
> Any idea, what might be the problem?
>
> Best regards,
> Dennis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
