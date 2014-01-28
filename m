Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57425 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172AbaA1TFu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 14:05:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1W8Dym-0005Vx-Sx
	for linux-wireless@vger.kernel.org; Tue, 28 Jan 2014 20:05:48 +0100
Received: from p5dc29b50.dip0.t-ipconnect.de ([93.194.155.80])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jan 2014 20:05:48 +0100
Received: from beweta by p5dc29b50.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jan 2014 20:05:48 +0100
To: linux-wireless@vger.kernel.org
From: Benedikt Schwarz <beweta@gmx.com>
Subject: Re: iwlwifi: Upload rate is ten times faster on Windows
Date: Tue, 28 Jan 2014 20:05:38 +0100
Message-ID: <52E7FF82.3040400@gmx.com> (sfid-20140128_200554_439370_E1314003)
References: <lc31d9$sma$1@ger.gmane.org> <52E5A0AE.7000009@erley.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
In-Reply-To: <52E5A0AE.7000009@erley.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pat,

Am 27.01.2014 00:56, schrieb Pat Erley:
> On 01/26/2014 07:09 AM, Benedikt Schwarz wrote:
>> Hi,
>>
>> the upload rate of my Intel Centrino Wireless-N 100 BGN (REV=0x6C) with
>> firmware version 39.31.5.1 build 32895 is about ten times faster on
>> Windows 7 (~ 4500 KB/s) than on Linux (~ 500 KB/s) when uploading files
>> to my NAS device. I'm running Kubuntu 13.10 with kernel
>> 3.12.0-031200-generic.
>>
>> What could be the reason for this problem?
> 
> Some questions which will greatly help in getting this resolved:
> 
> How are you connecting to the NAS?  Samba/Cifs?  NFS?  FTP?

A Samba/CIFS connection.


> How are you measuring your bandwidth?

I use bandwidth monitors.


> Check /etc/modprobe.d/* for a line that has something like:
> 
> iwlwifi 11n_disable=1

I haven't found a line like this in any of these files in /etc/modprobe.d/


> A lot of distributions have that on by default as there have been issues
> with the iwlwifi driver using 802.11n.
> 
> Are you connecting to an open or wpa1+tkip access point?  Try using
> wpa2+ccmp instead.  This is required for 802.11n to work.  Windows may
> not be enforcing that portion of the standard.

I already use WPA2.


Regards,
Benedikt Schwarz

