Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:43872 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab0FUSuC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 14:50:02 -0400
MIME-Version: 1.0
In-Reply-To: <lc60d4toGTL.A.QzD._LpHMB@chimera>
References: <lc60d4toGTL.A.QzD._LpHMB@chimera>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 21 Jun 2010 11:49:33 -0700
Message-ID: <AANLkTikVpTyNyYWf5xIO_3ok4OwbhxoiD40G3PAK8zp8@mail.gmail.com>
Subject: Re: 2.6.35-rc3: Reported regressions from 2.6.34
To: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	reinette chatre <reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 20, 2010 at 3:11 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message contains a list of some regressions from 2.6.34,
> for which there are no fixes in the mainline known to the tracking team.
> If any of them have been fixed already, please let us know.
>
> If you know of any other unresolved regressions from 2.6.34, please let us
> know either and we'll add them to the list.  Also, please let us know
> if any of the entries below are invalid.
>
> Each entry from the list will be sent additionally in an automatic reply
> to this message with CCs to the people involved in reporting and handling
> the issue.
>
>
> Listed regressions statistics:
>
>  Date          Total  Pending  Unresolved
>  ----------------------------------------
>  2010-06-21       46       37          26
>  2010-06-09       15       13          10

Leaving only the 802.11, and Bluetooth (none) ones:

> Unresolved regressions
> ----------------------


> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16235
> Subject         : [REGRESSION] [IWL3945] Broadcast is broken?
> Submitter       : Maciej Rutecki <maciej.rutecki@gmail.com>
> Date            : 2010-06-14 17:24 (7 days old)
> Message-ID      : <201006141924.24061.maciej.rutecki@gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=127653628301300&w=2

As noted by Maxim, the fix is in some Intel tree, but not upstream yet
(if so why ?)

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16232
> Subject         : 2.6.35-rc3 - WARNING:iwl_set_dynamic_key
> Submitter       : Mario Guenterberg <mario.guenterberg@googlemail.com>
> Date            : 2010-06-14 11:55 (7 days old)
> Message-ID      : <20100614115510.GA7904@guenti-laptop>
> References      : http://marc.info/?l=linux-kernel&m=127651695627147&w=2

Rafael, this one actually has a supplied patch by Reinette and she's
waiting on the user.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16201
> Subject         : SIOCGIWFREQ ioctl fails to get frequency info
> Submitter       : nuh <nuh@mailinator.net>
> Date            : 2010-06-14 10:45 (7 days old)

John is waiting on some user sample code to reproduce.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16176
> Subject         : Microcode errors with iwl3945
> Submitter       : Steinar H. Gunderson <sgunderson@bigfoot.com>
> Date            : 2010-06-10 19:28 (11 days old)

One issue replaced with another, but the microcode issues seems to be
fixed now on rc3.

> Regressions with patches
> ------------------------


> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16196
> Subject         : 2.6.35-rc2-git1 - WARNING: at net/wireless/mlme.c:341 cfg80211_send_assoc_timeout+0x107/0x11e [cfg80211]()
> Submitter       : Miles Lane <miles.lane@gmail.com>
> Date            : 2010-06-07 19:06 (14 days old)
> Message-ID      : <AANLkTinmZh9GnrZLzOGi5Q_xHbky8cKdHAkOnsIA6_dZ@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=127593758817428&w=2
> Handled-By      : Johannes Berg <johannes.berg@intel.com>
> Patch           : http://marc.info/?l=linux-wireless&m=127608099427316&w=2

Patch confirmed to work.

> For details, please visit the bug entries and follow the links given in
> references.
>
> As you can see, there is a Bugzilla entry for each of the listed regressions.
> There also is a Bugzilla entry used for tracking the regressions from 2.6.34,
> unresolved as well as resolved, at:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=16055
>
> Please let the tracking team know if there are any Bugzilla entries that
> should be added to the list in there.
>
> Thanks!
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
