Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:47150 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbYF1OyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 10:54:08 -0400
Received: by an-out-0708.google.com with SMTP id d40so184730and.103
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 07:54:05 -0700 (PDT)
Message-ID: <8db104800806280754n2d679198qfb77e5d9d29ae071@mail.gmail.com> (sfid-20080628_165412_838482_50258115)
Date: Sat, 28 Jun 2008 16:54:05 +0200
From: "=?UTF-8?Q?Pin-Sho/=E9=A6=AE=E5=93=81=E7=A2=A9?="
	<chessmani@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Ad-hoc not working (ICS Kubuntu Hardy to XP host) with iwl4965
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I have a T61 with Kubuntu Hardy freshly installed and fully upgraded
and I want to connect it to an XP host with Internet Connection
Sharing enabled. I have been able to do so successfully with an XP and
a Vista with intel 4965, but with Hardy it is not working.

Driver version: 1.2.25

The commands I use are:

sudo ifconfig wlan0 down
sudo iwconfig wlan0 mode ad-hoc
sudo iwconfig wlan0 essid blabla
sudo ifconfig wlan0 up
sudo dhclient wlan0

(no key is set)

After this, the dhclient does never discover an IP through the dhcp
server on the XP host. It gives wlan0:avahi an ip, but it's not
192.168.0.x. Configuring the IP manually does not work either. It
looks as if there is not even communication between the devices.

Ifconfig gives wlan0 with an associated cell, essid and ad-hoc mode,
but signal level is 0.

I have tried disabling ipv6 with no result.

I have downloaded and tried compat-wireless from 2 days ago and it did
not work either. However, it connected intermitently with an average
of 91% of lost packets.

Is this a bug? I opened a thread in ubuntuforums
(http://ubuntuforums.org/showthread.php?t=838775) and nobody replied.
I searched in the mail list archives and the posts I found suggest
that ad-hoc should be working fine.

Any thoughts?
