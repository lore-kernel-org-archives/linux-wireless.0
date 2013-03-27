Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40309 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab3C0TPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 15:15:05 -0400
Message-ID: <1364411696.8388.21.camel@jlt4.sipsolutions.net> (sfid-20130327_201511_651396_51FE0050)
Subject: Re: iwlwifi unable to reconnect after suspend since v3.9-rc1
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Date: Wed, 27 Mar 2013 20:14:56 +0100
In-Reply-To: <87txnwacdw.fsf@sycorax.lbl.gov>
References: <87li993mug.fsf@sycorax.lbl.gov>
	 <1364390086.8388.7.camel@jlt4.sipsolutions.net>
	 <87r4j021ac.fsf@sycorax.lbl.gov>
	 <1364406085.8388.11.camel@jlt4.sipsolutions.net>
	 <87ip4cg1qg.fsf@sycorax.lbl.gov>
	 <1364410962.8388.19.camel@jlt4.sipsolutions.net>
	 <87txnwacdw.fsf@sycorax.lbl.gov>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-27 at 12:08 -0700, Alex Romosan wrote:

> > Are you sure this only happens after suspend/resume? It seems like it
> > would always happen? At least if there was a beacon in the scan results
> > already, which should probably always be the case...
> 
> no, it always happens, but i only noticed it after suspend/resume. when
> i suspend i do an ifdown (because i haven't figured out a way to
> convince my new access point not to drop idle connections) and then i do
> an ifup to reconnect on resume. when i'm testing it now, i just take the
> network down and then try to bring it back up.

Ah, right, I guess I'm a little surprised it ever works at all ... We'll
see in the log though.

johannes

