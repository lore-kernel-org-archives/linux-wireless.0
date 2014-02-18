Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59819 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbaBRQIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 11:08:20 -0500
Received: by mail-ob0-f174.google.com with SMTP id uy5so18681392obc.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Feb 2014 08:08:19 -0800 (PST)
Message-ID: <53038571.7040503@lwfinger.net> (sfid-20140218_170823_465590_01487C7E)
Date: Tue, 18 Feb 2014 10:08:17 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: shankar swaminathan <shankswa@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211 support for RTL chipset
References: <CADNhdGEVUK5rJBisaAYQXfWBUBz+KkSHb5JSRtK4JuALOad+WA@mail.gmail.com>
In-Reply-To: <CADNhdGEVUK5rJBisaAYQXfWBUBz+KkSHb5JSRtK4JuALOad+WA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2014 06:14 AM, shankar swaminathan wrote:
> Hi,
>
> I am trying to install and get an USB WiFi dongle in AP ("Master")
> mode on linux kernel 3.3.4.
>
> I am not able to get the device to work with mac80211 / cfg80211
> driver --> iw does not work but iwconfig works.
>
> Do you know if the RTL 8188CUS and RTL 8188EUS chipsets support mac80211?

Driver rtl8192cu for the RTL8188CUS does use mac80211. Driver r8188eu for the 
RTL8188EU does not.

Larry


