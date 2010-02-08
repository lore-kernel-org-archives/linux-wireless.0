Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f172.google.com ([209.85.222.172]:48148 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab0BHS0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 13:26:50 -0500
Received: by pzk2 with SMTP id 2so117949pzk.21
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2010 10:26:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 8 Feb 2010 10:26:29 -0800
Message-ID: <43e72e891002081026x6757793atcb07cac1153e53c5@mail.gmail.com>
Subject: Re: 2.6.33-rc7: Reported regressions 2.6.31 -> 2.6.32
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 7, 2010 at 4:13 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

Only one 802.11 regression listed:

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14624
> Subject         : ath9k: BUG kmalloc-8192: Poison overwritten
> Submitter       : Miles Lane <miles.lane@gmail.com>
> Date            : 2009-11-12 4:58 (88 days old)
> References      : http://marc.info/?l=linux-kernel&m=125800196520396&w=4

For which we still need a recipe to reproduce as we have been unable to yet.

  Luis
