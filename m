Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40268 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab3C0TMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 15:12:03 -0400
Message-ID: <1364411509.8388.20.camel@jlt4.sipsolutions.net> (sfid-20130327_201220_002011_E6BB49A7)
Subject: Re: iwlwifi unable to reconnect after suspend since v3.9-rc1
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Date: Wed, 27 Mar 2013 20:11:49 +0100
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

> > Can you enable iwlwifi debugging and set the iwlwifi module parameter
> > debug=0x40000000 ? I have a feeling you'll see something like
> > "PASSIVE_NO_RX" in there.
> 
> i'll do it and let you know. i have iwlwifi compiled in the kernel, how
> do i specify it at boot time?

Oh, you can either specify iwlwifi.debug=0x40000000 or just do

echo 0x40000000 > /sys/module/iwlwifi/parameters/debug

johannes

