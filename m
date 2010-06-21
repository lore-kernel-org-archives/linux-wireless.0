Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34694 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab0FUSct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 14:32:49 -0400
MIME-Version: 1.0
In-Reply-To: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 21 Jun 2010 11:32:28 -0700
Message-ID: <AANLkTinRKbRPPzEqhdcexISRJKViBldG01cj9aF0wPx-@mail.gmail.com>
Subject: Re: 2.6.35-rc3: Reported regressions 2.6.33 -> 2.6.34
To: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	reinette chatre <reinette.chatre@intel.com>, j@w1.fi,
	adobriyan@gmail.com, tj@kernel.org,
	Satish Eerpini <eerpini@gmail.com>,
	Petr Pisar <petr.pisar@atlas.cz>, Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 20, 2010 at 3:32 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message contains a list of some post-2.6.33 regressions introduced before
> 2.6.34, for which there are no fixes in the mainline known to the tracking team.
> If any of them have been fixed already, please let us know.
>
> If you know of any other unresolved post-2.6.33 regressions, please let us know
> either and we'll add them to the list.  Also, please let us know if any
> of the entries below are invalid.
>
> Each entry from the list will be sent additionally in an automatic reply to
> this message with CCs to the people involved in reporting and handling the
> issue.
>
>
> Listed regressions statistics:
>
>  Date          Total  Pending  Unresolved
>  ----------------------------------------
>  2010-06-21      114       36          28
>  2010-06-13      111       40          34
>  2010-05-09       80       27          24
>  2010-05-04       76       26          22
>  2010-04-20       64       35          34
>  2010-04-07       48       35          33
>  2010-03-21       15       13          10

I'm going to just leave in the 802.11, Bluetooth and PCMCIA ones below:

> Unresolved regressions
> ----------------------


> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16111
> Subject         : hostap_pci: infinite registered netdevice wifi0
> Submitter       : Petr Pisar <petr.pisar@atlas.cz>
> Date            : 2010-06-02 20:55 (19 days old)

The last entry on this one says we are not sure how to fix this...

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16084
> Subject         : iwl3945 bug in 2.6.34
> Submitter       : Satish Eerpini <eerpini@gmail.com>
> Date            : 2010-05-23 6:37 (29 days old)
> Message-ID      : <AANLkTik_7rxDBc0TKlAfoYyM5S6Cf_Hyxbr4W5ORnTsq@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=127459596015626&w=2

This is getting some love by Reinette.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15717
> Subject         : bluetooth oops
> Submitter       : Pavel Machek <pavel@ucw.cz>
> Date            : 2010-03-14 20:14 (99 days old)
> Message-ID      : <20100314201434.GE22059@elf.ucw.cz>
> References      : http://marc.info/?l=linux-kernel&m=126859771528426&w=4
> Handled-By      : Marcel Holtmann <marcel@holtmann.org>

Pavel, is this still happening or was just spurious on 2.6.34-rc1?

> Regressions with patches
> ------------------------


> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16138
> Subject         : PCMCIA regression
> Submitter       : Mikulas Patocka <mpatocka@redhat.com>
> Date            : 2010-05-25 20:25 (27 days old)
> Message-ID      : <Pine.LNX.4.64.1005251619020.12278@hs20-bc2-1.build.redhat.com>
> References      : http://marc.info/?l=linux-kernel&m=127481913909672&w=2
> Handled-By      : Dominik Brodowski <linux@brodo.de>
> Patch           : https://bugzilla.kernel.org/attachment.cgi?id=26685

Linville, are you to get PCMCIA stuff now? Anyway Rafael, please
remove this, this is fixed.

> For details, please visit the bug entries and follow the links given in
> references.
>
> As you can see, there is a Bugzilla entry for each of the listed regressions.
> There also is a Bugzilla entry used for tracking the regressions introduced
> between 2.6.33 and 2.6.34, unresolved as well as resolved, at:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=15310
>
> Please let the tracking teak know if there are any Bugzilla entries that
> should be added to the list in there.
>
> Thanks!
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
