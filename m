Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from erley.org ([97.107.129.9]:33303 "EHLO remote.erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab3CBKcU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 05:32:20 -0500
Message-ID: <5131D2D1.7020709@erley.org> (sfid-20130302_113223_014841_F112D9F6)
Date: Sat, 02 Mar 2013 05:22:09 -0500
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Abdelmuhaimen Seaudi <aseaudi@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Fwd: Intel Wifilink 5100 AGN - Does it support Access Point Infrastructure
 Mode ?
References: <CABFmVg5sPub5Q4n+7PnkUn7weQLEUabONeJQZY6aFS2yFZAf2Q@mail.gmail.com> <CABFmVg5AaTG-F_myEA=WGdYpnwN9X=QfLcjKvwJ1-SUX0quaOg@mail.gmail.com> <CABFmVg5J6nWfBFL1VAsD+V3X_xPD6v4wLz0X5Wv4p082Trdshw@mail.gmail.com>
In-Reply-To: <CABFmVg5J6nWfBFL1VAsD+V3X_xPD6v4wLz0X5Wv4p082Trdshw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/02/2013 04:51 AM, Abdelmuhaimen Seaudi wrote:
> Hello iwlwifi support,
> I want to run my Wifi Intel WifiLink 5100 AGN in Access Point
> Infrstructure Mode, so that I can connect via WiFi with other devices
> to my workstation.
> This is under Ubuntu Linux 12.10.
> I have tried setting the wlan0 to run in master mode, but it gives me
> error, as shown below.
> Is it possible to run this WiFi radio in AP Infrstrucutre mode ? How ?
> Thanks,
>
> aseaudi@Home:~$ iwconfig
> wlan0     IEEE 802.11abgn  ESSID:"3Com"
>            Mode:Managed  Frequency:2.462 GHz  Access Point: 00:22:57:1F:C4:2B
>            Bit Rate=48 Mb/s   Tx-Power=15 dBm
>            Retry  long limit:7   RTS thr:off   Fragment thr:off
>            Power Management:off
>            Link Quality=51/70  Signal level=-59 dBm
>            Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>            Tx excessive retries:0  Invalid misc:468   Missed beacon:0
> lo        no wireless extensions.
> eth0      no wireless extensions.
>
> aseaudi@Home:~$ sudo iwconfig wlan0 mode master
> Error for wireless request "Set Mode" (8B06) :
>      SET failed on device wlan0 ; Invalid argument.

http://linuxwireless.org/en/users/Documentation/hostapd

Master mode requires userspace to handle setup and control.  That page 
should cover most/all of what you need.

Pat Erley

