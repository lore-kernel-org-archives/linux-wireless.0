Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53453 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2ACTtR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 14:49:17 -0500
Received: by iaeh11 with SMTP id h11so31329860iae.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2012 11:49:16 -0800 (PST)
Message-ID: <4F035BB7.8030203@lwfinger.net> (sfid-20120103_204920_705593_31B328AD)
Date: Tue, 03 Jan 2012 13:49:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Williams <john@pond-weed.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [Question] Realtek USB 0bda:8176 as AP?
References: <20120101130000.57429e74@buffy.scoobygang>
In-Reply-To: <20120101130000.57429e74@buffy.scoobygang>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/01/2012 07:00 AM, John Williams wrote:
> Hello list,
>
> I see there was a discussion on this list about three months ago about
> using an RTL8192CU (usb 0bda:8176) in access point mode. I've just
> bought one and I've got the same problem: hostapd just prints this in a
> loop until it gives up:
>
> WPA: 00:24:23:0c:9c:2f WPA_PTK entering state PTKSTART
> wlan0: STA 00:24:23:0c:9c:2f WPA: sending 1/4 msg of 4-Way Handshake
> WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8
>    kde_len=0 keyidx=0 encr=0)
> IEEE 802.1X: 00:24:23:0c:9c:2f TX status -version=2 type=3
>    length=95 - ack=1
> wlan0: STA 00:24:23:0c:9c:2f
> WPA: EAPOL-Key timeout
>
> This is with the driver from compat_wireless as of 2011-12-29.
>
> It works fine with the driver downloaded from the realtek website
> (provided that I also use their patched version of hostapd), so it's
> not a hardware problem.
>
> If anyone could point me to the area in the driver where it is supposed
> to receive the missing message, I would be happy to have a go at
> debugging it.

I do not know what the problem with using the kernel versions of 
rtl8192{ce,cu,se,de} as an AP. I have been going through the differences between 
the version available on the Realtek web site and the kernel sources. Sorting 
out the differences is mind numbing, and will take a while to complete.

Patches will be posted on the wireless ML when I get a fix.

Larry

