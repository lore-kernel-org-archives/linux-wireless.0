Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56501 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab2FGKlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 06:41:45 -0400
Received: by pbbrp8 with SMTP id rp8so897681pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 03:41:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20120607T121239-785@post.gmane.org>
References: <loom.20120607T100950-564@post.gmane.org>
	<CAJwzM1mTyOv6cUjTQ00-Q-5aW872kwyBPgnH9Pnk82fLZ+-J2w@mail.gmail.com>
	<loom.20120607T121239-785@post.gmane.org>
Date: Thu, 7 Jun 2012 16:11:44 +0530
Message-ID: <CAJwzM1n2-K+J5ado9fUVBNuOumAfp0R0kwHj6jFSuOFJHap61Q@mail.gmail.com> (sfid-20120607_124148_858731_C396ADAA)
Subject: Re: mwifiex:Testing AP functionality with hostapd
From: Avinash Patil <avinashapatil@gmail.com>
To: =?ISO-8859-1?Q?Hans_Kr=F6ner?= <hanskroner@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hans,

mwifiex AP functionality has been tested against following hostapd revision:

http://hostap.epitest.fi/gitweb/gitweb.cgi?p=hostap.git;a=snapshot;h=5f32f79c6e071f02076e09931adc8fc4e0ecd383;sf=tgz

Can you please test mwifiex AP setup against this hostapd revision and
let me know result?

Regards,
Avinash

On Thu, Jun 7, 2012 at 3:53 PM, Hans Kröner <hanskroner@gmail.com> wrote:
> Hi Avinash,
>
> Thanks for your reply!
>
> i)    Firmware version is reported as "mwifiex 1.0 (14.57.5.p69)"
>
> ii)   hostapd version is "v2.0-devel" I took it from git at
>      git://w1.fi/srv/git/hostap.git and used the config in my previous post
>      to build it. I'm at commit 5b3763336466f2c55611437cb924aeee45f7203e
>
> iii)  Output of hostapd "-ddd" is the same as my previous post, which used
>      "-dd". Here it is:
>
>                random: Trying to read entropy from /dev/random
>                Configuration file: hostapd-minimal.conf
>                nl80211: interface uap0 in phy phy0
>                rfkill: initial event: idx=0 type=2 op=0 soft=0 hard=0
>                rfkill: initial event: idx=1 type=1 op=0 soft=0 hard=0
>                nl80211: Disable use_monitor with device_ap_sme since no monitor mode
>                support detected
>                nl80211: Add own interface ifindex 5
>                nl80211: Set mode ifindex 5 iftype 3 (AP)
>                nl80211: Setup AP - device_ap_sme=1 use_monitor=0
>                nl80211: Subscribe to mgmt frames with AP handle 0x74608 (device SME)
>                nl80211: Register frame type=0xd0 nl_handle=0x74608
>                nl80211: Register frame match - hexdump(len=0): [NULL]
>                nl80211: Register frame command failed (type=208): ret=-95 (Operation not
>                supported)
>                nl80211: Register frame match - hexdump(len=0): [NULL]
>                nl80211: Failed to set interface uap0 into AP mode
>                netlink: Operstate: linkmode=0, operstate=6
>                nl80211: Set mode ifindex 5 iftype 2 (STATION)
>                nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
>                nl80211: Try mode change after setting interface down
>                nl80211: Set mode ifindex 5 iftype 2 (STATION)
>                nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
>                nl80211: Set mode ifindex 5 iftype 2 (STATION)
>                nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
>                nl80211: Set mode ifindex 5 iftype 2 (STATION)
>                nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
>                nl80211: Set mode ifindex 5 iftype 2 (STATION)
>                nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
>                nl80211: Set mode ifindex 5 iftype 2 (STATION)
>                nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
>                nl80211: Set mode ifindex 5 iftype 2 (STATION)
>                nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
>                nl80211: Set mode ifindex 5 iftype 2 (STATION)
>                nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
>                nl80211: Set mode ifindex 5 iftype 2 (STATION)
>                nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
>                nl80211: Set mode ifindex 5 iftype 2 (STATION)
>                nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
>                nl80211: Set mode ifindex 5 iftype 2 (STATION)
>                nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
>                nl80211: Interface mode change to 2 from 3 failed
>                nl80211 driver initialization failed.
>
> Thanks for your help!!!
>
> Best Regards,
>
> Hans
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
