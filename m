Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f189.google.com ([209.85.222.189]:48687 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab0BAS0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 13:26:17 -0500
Received: by pzk27 with SMTP id 27so5096128pzk.33
        for <linux-wireless@vger.kernel.org>; Mon, 01 Feb 2010 10:26:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Feb 2010 10:25:57 -0800
Message-ID: <43e72e891002011025p449e5169p1d4266b38be1c2c8@mail.gmail.com>
Subject: Re: 2.6.33-rc6: Reported regressions 2.6.31 -> 2.6.32
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Miles Lane <miles.lane@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 31, 2010 at 4:38 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Unresolved regressions
> ----------------------

Only one for 802.11:

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14624
> Subject         : ath9k: BUG kmalloc-8192: Poison overwritten
> Submitter       : Miles Lane <miles.lane@gmail.com>
> Date            : 2009-11-12 4:58 (81 days old)
> References      : http://marc.info/?l=linux-kernel&m=125800196520396&w=4

Is this a regression though? Do we know for sure it was not happening
on 2.6.31? Either way so far we have been unable to identify a way to
reproduce this. It should be noted Miles has reported this is still
present on 2.6.33 stuff. Miles, can you give further instructions as
to how you arrive to this poison? How are you using your device, how
often does it happen, when does it happen, etc.

  Luis
