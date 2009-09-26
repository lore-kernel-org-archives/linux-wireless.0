Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f185.google.com ([209.85.210.185]:55747 "EHLO
	mail-yx0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZIZP60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 11:58:26 -0400
Received: by yxe15 with SMTP id 15so4139168yxe.22
        for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2009 08:58:30 -0700 (PDT)
Message-ID: <4ABE3A29.5070006@lwfinger.net>
Date: Sat, 26 Sep 2009 10:58:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org
Subject: Re: 2.6.31-git wireless broken
References: <Pine.LNX.4.64.0909241737390.20846@sister.anvils>  <1253813740.3868.324.camel@johannes.local>  <Pine.LNX.4.64.0909241859020.25022@sister.anvils>  <1253816614.3868.406.camel@johannes.local>  <Pine.LNX.4.64.0909242036270.7469@sister.anvils>  <1253856038.3868.500.camel@johannes.local>  <Pine.LNX.4.64.0909250838420.3783@sister.anvils>  <1253868214.3868.713.camel@johannes.local>  <Pine.LNX.4.64.0909251506260.11390@sister.anvils> <1253970049.5122.31.camel@johannes.local> <Pine.LNX.4.64.0909261625050.4336@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909261625050.4336@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hugh Dickins wrote:
> On Sat, 26 Sep 2009, Johannes Berg wrote:
>> On Fri, 2009-09-25 at 15:15 +0100, Hugh Dickins wrote:
>>> a9a11622c5c742c115fad371c0397ae86dd3bb67 is first bad commit
>>> commit a9a11622c5c742c115fad371c0397ae86dd3bb67
>>> Author: Johannes Berg <johannes@sipsolutions.net>
>>> Date:   Mon Jul 27 12:01:53 2009 +0200
>>>
>>>     cfg80211: self-contained wext handling where possible
>> Heh, fun.
>>
>> Well the problem appears to be that wpa_supplicant isn't getting started
>> by your distro any more. Unfortunately I'm not familiar with opensuse.
>> It seems it thinks the device isn't wireless but wired, since it starts
>> ifplugd. OTOH maybe it wants ifplugd for wireless too? It's possible in
>> theory.
> 
> No, ifplugd was my choice: IIRC, at some stage of installation you're
> given a choice between traditional ifplugd and super new NetworkManager:
> my choice has been ifplugd (after being somehow burnt by NetworkManager
> once in the past).

FWIW, the current version of NetworkManager used by the KDE 3.5
desktop in openSUSE 11.1 works, as does the Gnome version. There have
been problems with KDE4.2 and earlier, but 4.3 works.

I have been testing openSUSE 11.2. As of Milestone 7, wireless
networking works with KDE and Gnome in both i386 and x86_64
architectures. I have also tested networks with no encryption, WEP,
WPA TKIP, and WPA2 TKIP.

My inclination is to set wired connections with ifplugd, but wireless
to "on boot".

Larry
