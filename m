Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbXF3IG0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2007 04:06:26 -0400
Subject: Re: [RFC/PATCH] debug workqueue deadlocks with lockdep
From: Ingo Molnar <mingo@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Oleg Nesterov <oleg@tv-sign.ru>, mingo@elte.hu,
	Thomas Sattler <tsattler@gmx.de>
In-Reply-To: <1183052001.4089.2.camel@johannes.berg>
References: <1182969638.4769.56.camel@johannes.berg>
	 <1183048429.4089.1.camel@johannes.berg>
	 <1183052001.4089.2.camel@johannes.berg>
Content-Type: text/plain
Date: Sat, 30 Jun 2007 10:05:28 +0200
Message-Id: <1183190728.7932.43.camel@earth4>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-06-28 at 19:33 +0200, Johannes Berg wrote:
> No, that's not right either, but Arjan just helped me a bit with how
> lockdep works and I think I have the right idea now. Ignore this for
> now, I'll send a new patch in a few days.

ok. But in general, this is a very nice idea!

i've Cc:-ed Oleg. Oleg, what do you think? I think we should keep all
the workqueue APIs specified in a form that makes them lockdep coverable
like Johannes did. This debug mechanism could have helped with the
recent DVB lockup that Thomas Sattler reported.

	Ingo

