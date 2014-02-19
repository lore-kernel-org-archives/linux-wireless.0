Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:38070 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaBSLoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 06:44:02 -0500
Received: by mail-we0-f179.google.com with SMTP id q58so223773wes.38
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 03:44:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <53038571.7040503@lwfinger.net>
References: <CADNhdGEVUK5rJBisaAYQXfWBUBz+KkSHb5JSRtK4JuALOad+WA@mail.gmail.com>
	<53038571.7040503@lwfinger.net>
Date: Wed, 19 Feb 2014 17:14:01 +0530
Message-ID: <CADNhdGGVuGD5StR5wByfEGgd4LRLa3m5xfdpRspQFiZd3cLB0w@mail.gmail.com> (sfid-20140219_124409_902924_C0CD1BE0)
Subject: Re: mac80211 support for RTL chipset
From: shankar swaminathan <shankswa@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was able to get RTL8188CUS chipset to work with the rtl8192cu driver
in AP mode.
It is responding to Probe Requests, however Beacons are not being
transmitted continuously - even when I use hostapd!!
Could you help in debugging this.

thanks,
-shankar


On Tue, Feb 18, 2014 at 9:38 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 02/18/2014 06:14 AM, shankar swaminathan wrote:
>>
>> Hi,
>>
>> I am trying to install and get an USB WiFi dongle in AP ("Master")
>> mode on linux kernel 3.3.4.
>>
>> I am not able to get the device to work with mac80211 / cfg80211
>> driver --> iw does not work but iwconfig works.
>>
>> Do you know if the RTL 8188CUS and RTL 8188EUS chipsets support mac80211?
>
>
> Driver rtl8192cu for the RTL8188CUS does use mac80211. Driver r8188eu for
> the RTL8188EU does not.
>
> Larry
>
>
