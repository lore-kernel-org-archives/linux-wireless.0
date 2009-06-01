Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout026.mac.com ([17.148.16.101]:40325 "EHLO
	asmtpout026.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbZFAVsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 17:48:36 -0400
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Received: from MainMacMini.lan ([80.176.168.49])
 by asmtp026.mac.com (Sun Java(tm) System Messaging Server 6.3-8.01 (built Dec
 16 2008; 32bit)) with ESMTPSA id <0KKK00JYNV4L6340@asmtp026.mac.com> for
 linux-wireless@vger.kernel.org; Mon, 01 Jun 2009 13:48:25 -0700 (PDT)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>
Message-id: <21CA6416-CDD3-4435-8E35-9EADE00A8B6F@me.com>
From: Tim Hawkins <tim.hawkins@me.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
In-reply-to: <1243888982.13273.21.camel@maxim-laptop>
Subject: Re: Pending ath5k bugs
Date: Mon, 01 Jun 2009 21:48:21 +0100
References: <1243888982.13273.21.camel@maxim-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I can confirm 1 & 2, i have the same problems on my aspire one.

Also wrt: 1

The reported signal strength is much lower than running say madwifi on  
the same hardware/os.

On 1 Jun 2009, at 21:43, Maxim Levitsky wrote:

> Hi,
>
> Just like ath9k thread, here is the list of bugs, I have seen on my
> aspire one (with ath5k).
>
> This is an AR2425 device.
>
>
> #1) - Data transfer often stalls, sometimes for few seconds, sometimes
> for much longer periods.
>
> Transfer rate doesn't affect this, nether does network load (happens
> much more often when it is high, but also happens, while it is  
> medium to
> low).
>
> I observed that, resetting the phy by triggering a scan, sometimes  
> help,
> although running the scan inside a 2 second per iteration loop,  
> doesn't
> prevent this stall to occur.
>
> Also encryption doesn't play any role in this, I have seen  same
> scenario on open network configuration as well.
>
>
> #2) - Driver sometimes doesn't wake the device up, after resume from
> ram/disk. It happens not much often, but when it does, only a power
> cycle (reboot or poweroff) helps to recover the device, and nether  
> s2ram
> nor s2disk do anything.
>
>
>
> #3) Ath5k often panics the kernel when it is in ibss/ap mode. This
> reported to be fixed, but I use latest wireless-testing (less that 3  
> day
> old, on average)
>
>
> #4) Ath5k doesn't send beacons, when hostapd is run for the first  
> time.
>
>
> #5) Can't send any frames between AP (ath5k) and a client.
> But If I create a second monitor iface (in addition to the one hostapd
> have created) I do see the frames from client on AP.
>
>
> I especially hate bug #1, and would be happy to see bug #2 fixed.
> I don't use AP mode much yet, but it would be nice if it were in  
> working
> state.
>
>
>
> Best regards,
> 	Maxim Levitsky
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

