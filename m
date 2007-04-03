Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:47684 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030275AbXDCO0D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2007 10:26:03 -0400
Message-ID: <461263FF.7040707@lwfinger.net>
Date: Tue, 03 Apr 2007 09:26:07 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: WPA does not connect to bcm43xx-mac80211 when using NetworkManager
References: <460E2B8C.4030002@gmail.com>	 <200703311503.53445.flamingice@sourmilk.net>	 <f6ca9fed0703311256m1b14ec35p836a62de532dd804@mail.gmail.com>	 <200703311700.52792.flamingice@sourmilk.net>	 <1175388624.10282.0.camel@localhost.localdomain>	 <46107D79.3060706@lwfinger.net> <1175487124.30381.16.camel@localhost.localdomain>
In-Reply-To: <1175487124.30381.16.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Sun, 2007-04-01 at 22:50 -0500, Larry Finger wrote:
>> Dan,
>>
>> My bcm43xx-mac80211 system generates the following log entries when trying to connect using WPA-PSK
>> TKIP controlled by NetworkManager. The same configuration works with bcm43xx-softmac.
> 
> So what you're saying here is that NM works with softmac, but doesn't
> work with mac80211?

Yes.

> 
> Hmm; any idea why that happens?  Can we figure out more about the
> association process inside the driver?  If it works with wpa_supplicant,
> can you increase the debugging output of wpa_supplicant in the NM
> sources in nm-device-802-11-wireless.c in supplicant_exec() by adding
> another argument to argv with the value '-ddd'?

What version of NM will work with dbus-glib 0.71? I grabbed the svn archive, found it needed 0.72, 
and tried to install a newer version. I messed everything up and had to reinstall openSUSE again. I 
certainly don't want to go through that again!

Larry

