Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38289 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab0JDSYz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 14:24:55 -0400
MIME-Version: 1.0
In-Reply-To: <OjxVjYbf_EJ.A.ReC.pTPqMB@chimera>
References: <OjxVjYbf_EJ.A.ReC.pTPqMB@chimera>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 4 Oct 2010 11:17:32 -0700
Message-ID: <AANLkTingYRH0_1VP4Q5BqBO2rV7yWctVQ3kAcyB_mibK@mail.gmail.com>
Subject: Re: 2.6.36-rc6-git2: Reported regressions 2.6.34 -> 2.6.35
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>, dtonator@gmail.com,
	florian@mickler.org, oliver@neukum.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are the 802.11 and Bluetooth ones:

On Sun, Oct 3, 2010 at 2:36 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16691
> Subject         : IPW5100: iwlagn broken with 2.6.34.x to 2.6.35.2 update
> Submitter       : Can Celasun <dcelasun@gmail.com>
> Date            : 2010-08-21 08:28 (44 days old)

This is awaiting some new uCode code drop by Intel.

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16458
> Subject         : Bluetooth disabled after resume
> Submitter       : AttilaN <attila123456@gmail.com>
> Date            : 2010-07-25 09:33 (71 days old)

No followup on this one.

> Regressions with patches
> ------------------------
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16462
> Subject         : unable to connect to hidden SSID AP on legal channel 13
> Submitter       : Daniel J Blueman <daniel.blueman@gmail.com>
> Date            : 2010-07-25 17:06 (71 days old)
> Handled-By      : Johannes Berg <johannes.berg@intel.com>
> Patch           : https://bugzilla.kernel.org/attachment.cgi?id=31862

Fixed by Johannes, this was an Intel specific issue. Reviewed the
possibility of this also affecting mac80211 but since we lift the
passive scan on a beacon for the AP this should not affect mac80211 in
the future.

  Luis
