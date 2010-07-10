Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:44183 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab0GJDG4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jul 2010 23:06:56 -0400
Received: by pxi14 with SMTP id 14so1108163pxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jul 2010 20:06:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <xkNyyYrLiTN.A.s_G.7p7NMB@chimera>
References: <xkNyyYrLiTN.A.s_G.7p7NMB@chimera>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 9 Jul 2010 20:06:33 -0700
Message-ID: <AANLkTimFLbMn-X59Ff_m6Pv-cS9-Oal-ml2ZbT8xqFg-@mail.gmail.com>
Subject: Re: 2.6.35-rc4-git4: Reported regressions 2.6.33 -> 2.6.34
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	reinette chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Below are the 802.11 ones only. One for iwl3945, the other for iwlagn:

On Fri, Jul 9, 2010 at 5:24 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Unresolved regressions
> ----------------------

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16320
> Subject         : iwl3945 crashes, seems to be disconnecting from the PCI bus
> Submitter       : Satish <eerpini@gmail.com>
> Date            : 2010-07-01 08:24 (9 days old)

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15862
> Subject         : 2.6.34-rc4/5: iwlagn unusable until reload
> Submitter       : Nico Schottelius <nico-linux-20100427@schottelius.org>
> Date            : 2010-04-27 7:49 (74 days old)
> Message-ID      : <20100427074934.GB3261@ikn.schottelius.org>
> References      : http://marc.info/?l=linux-kernel&m=127235784004839&w=2
> Handled-By      : Johannes Berg <johannes@sipsolutions.net>

  Luis
