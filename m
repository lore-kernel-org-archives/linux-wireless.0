Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48725 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2ITMtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 08:49:49 -0400
Message-ID: <1348145425.4161.29.camel@jlt4.sipsolutions.net> (sfid-20120920_144954_421674_D2FCDB59)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Eric Dumazet <edumazet@google.com>
Cc: artem.bityutskiy@linux.intel.com, linux-wireless@vger.kernel.org,
	netdev <netdev@vger.kernel.org>
Date: Thu, 20 Sep 2012 14:50:25 +0200
In-Reply-To: <CANn89iLnv2kWLd_hTpMXjMJ=r+hOvb2q2Oy6L-s5+6SzqxYvjA@mail.gmail.com> (sfid-20120920_144655_166559_8ECC4537)
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	 <1347631355.5263.19.camel@sauron.fi.intel.com>
	 <1347640763.5263.24.camel@sauron.fi.intel.com>
	 <1347892887.7112.9.camel@sauron.fi.intel.com>
	 <1348142775.2388.10.camel@sauron.fi.intel.com>
	 <1348144524.4161.26.camel@jlt4.sipsolutions.net>
	 <CANn89iJkXrZPB14KU8xA-Dn8_n=H3J4-R60BTZFV+STF9_ASdA@mail.gmail.com>
	 <CANn89iKStHAwVZtpgQMzEpByGYG2FKpjSQsJFT-9qQmjw+KJ8g@mail.gmail.com>
	 <CANn89iLnv2kWLd_hTpMXjMJ=r+hOvb2q2Oy6L-s5+6SzqxYvjA@mail.gmail.com>
	 (sfid-20120920_144655_166559_8ECC4537)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-20 at 14:46 +0200, Eric Dumazet wrote:
> Or its the lines with CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS ?
> 
> What arch is it ?

x86

johannes

