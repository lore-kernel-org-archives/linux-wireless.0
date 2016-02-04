Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34330 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbcBDRjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 12:39:46 -0500
Received: by mail-oi0-f48.google.com with SMTP id w5so20020918oie.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 09:39:45 -0800 (PST)
Subject: Re: alfa awus036nhr v2 and module rtl8xxxu
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Drunk Cat <natserver2@gmail.com>
References: <loom.20160128T003525-188@post.gmane.org>
 <wrfjd1sco25f.fsf@redhat.com>
Cc: linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56B38CDF.9010806@lwfinger.net> (sfid-20160204_183949_860097_46C88F05)
Date: Thu, 4 Feb 2016 11:39:43 -0600
MIME-Version: 1.0
In-Reply-To: <wrfjd1sco25f.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/04/2016 10:45 AM, Jes Sorensen wrote:
> Drunk Cat <natserver2@gmail.com> writes:
>> problem: it does not connect to any wifi network you can see the time out on
>> dmesg
>>
>>
>>> lsusb
>>
>> Bus 002 Device 007: ID 0bda:817f Realtek Semiconductor Corp. RTL8188RU
>> 802.11n WLAN Adapter
>>
>>> iwconfig
>> wlp0s20u1  IEEE 802.11bgn  ESSID:off/any
>>            Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm
>>            Retry short limit:7   RTS thr=2347 B   Fragment thr:off
>>            Power Management:off
>>> dmesg
>
> Not sure what distribution you are running, but I am seeing problems
> with NetworkManager in recent Fedora.
>
> Could you try the following:
> 1) Unplug the WiFi dongle
> 2) (Re)load the driver (rmmod rtl8xxxu ; insmod rtl8xxxu)
> 3) Restart NetworkManager 'systemctl restart NetworkManager'
> 4) Plug in the WiFi dongle

Jes,

I can confirm what Drunk Cat sees. There is something different about the 
RTL8192RU as using the iwconfig utility shows no APs in the scan. I hope to get 
to debugging the problem soon.

Larry


