Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from redcondor2.peak.org ([69.59.192.56]:41033 "EHLO
	redcondor2.peak.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab1L0C2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Dec 2011 21:28:52 -0500
Message-ID: <4EF92B82.9080002@efn.org> (sfid-20111227_032902_176928_4E0DCF7B)
Date: Mon, 26 Dec 2011 16:20:50 -1000
From: Thomas <t-om@efn.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: greg@kroah.com, wireless <linux-wireless@vger.kernel.org>
Subject: Re: looking for Linux firmare/driver for powerbook g4
References: <4EF7BE93.4050001@efn.org> <4EF8A91D.5010001@lwfinger.net>
In-Reply-To: <4EF8A91D.5010001@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you for the quick, useful, and to the point response     =)

I suspect the key line that is the one we are looking for is:
BUS 001 Device 002:  ID  0bda:8172 Realtek Semiconductor Corp.
but I list the whole response below...
running my live ubuntu cd 10.04 when I type lsusb into the terminal 
window I get:
BUS 004 Device 001:  ID  1d6b:0001 Linux Foundation 1.1 root hub
BUS 003 Device 001:  ID  1d6b:0001 Linux Foundation 1.1 root hub
BUS 002 Device 004:  ID  05ac:8205 Apple, Inc. Bluetooth HCI
BUS 002 Device 003:  ID  05ac:030a Apple, Inc.  Internal Trackpad
BUS 002 Device 001:  ID  1d6b:0001 Linux Foundation 1.1 root hub
BUS 001 Device 002:  ID  0bda:8172 Realtek Semiconductor Corp.
BUS 001 Device 001:  ID  1d6b:0002 Linux Foundation 2.0  root hub

I'm also distressed because I find no gui for the wireless connection in 
Lubuntu, I know that is not your program, but I find it really weird 
that it seems to not exist
      I think I'm going to go to mint or puppy or stick with Ubuntu 
10.04...     I do not like the new desktop in the "precise" ubuntu...    
a very dysfunctional and un-editable dock!  IMO    Once again, not your 
issue    =)

Also, when I load ubuntu 10.04 live cd it says there are additional 
hardware drivers to download...    Broadcom B43    if I remember from 
last year, these are the ones for the airport extreme card, but it did 
not work this time    =(    besides, I want the n-type usb anyway    =)

I'm using the same USB WLAN device on my new macbook air with a program 
I downloaded from your web-page (last week?)
that program says (under "information") Utility Version 1.9.7 
(2011/11/11)    Driver version: v1081   and the program does not open a 
window (even tho the program is "on"/running when I have a different 
(borrowed) usb WLAN in the usb slot
     AND, when I do a lsusb on my macbook air, I get:
mmmmmm-MacBook-Air:~ nnnnn$ lsusb
-bash: lsusb: command not found
mmmmmm-MacBook-Air:~ nnnnn$ ls usb
ls: usb: No such file or directory
mmmmmm-MacBook-Air:~ nnnnn$ ls: usb
-bash: ls:: command not found

the same happens on my terminal on my 12" g4 running mac OS 10.4.10    

thank you for your attention here, I do appreciate it!
    Thomas




> On 12/25/2011 06:23 PM, Thomas wrote:
>> Hey, thanks for being there!
>> I was looking to instal Lubuntu onto my mac powerbook g4 12" 
>> (1.5g/1.25ram)
>> when I installed ubuntu 10.04 it had a driver available called 
>> "broadcom B43"
>> for my wi-fi, but on the live cd version of Lubuntu 12.04, I could 
>> not even find
>> anyway to access additional drivers OR the WLAN (wi-fi) settings or 
>> controls,
>> etc. and firefox told me I was off line (until I plugged in an 
>> ethernet cable)
>> I also have a USB wi-fi device that has no branding, but is called:
>> WLAN 11n Mini USB Adapter
>> FCC ID: WKLWL6203
>> mac 0002728E8A88
>>
>> Is there anything you can do to help me get my old powerbook to use 
>> this USB WLAN?
>> I'd rather use it (type n) than the internal (g style) "airport extreme"
>
> I have Mint 9 running on my Powerbook G4 Titanium. I bought the 
> machine to debug the big-endian issues for driver rtl8192cu. I have a 
> number of USB wireless devices, and all work just fine.
>
> Please post the output of the lsusb command so that we know the USB 
> IDs for your device. That will determine what driver it needs.
>
> Larry 

