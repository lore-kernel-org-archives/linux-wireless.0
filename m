Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:36345 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbaJWNCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 09:02:41 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: RE: 3.18-rc0: iwlegacy failed after a while
Date: Thu, 23 Oct 2014 13:02:37 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B552E3F@hasmsx107.ger.corp.intel.com> (sfid-20141023_150258_880254_0370191B)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Changed subject]
This is really iwlegacy and not iwlwifi.


> 
> Hi!
> 
> Full dmesg is in the attachment, I guess the troubles started with:
> 
> iwl3945 0000:03:00.0: Queue 4 stuck for 2004 ms.
> iwl3945 0000:03:00.0: On demand firmware reload
> iwl3945 0000:03:00.0: Master Disable Timed Out, 100 usec
> ieee80211 phy0: Hardware restart was requested
> iwl3945 0000:03:00.0: BSM uCode verification failed at addr
> 0x00003800+0 (of 900), is 0xa5\
> a5a5a2, s/b 0xf802020
> iwl3945 0000:03:00.0: Unable to set up bootstrap uCode: -5
> 
> Best regards,
> 								Pavel
> 
> --

Huh - I don't remember any change there, but you should ask the right person - iwlegacy maintainer :)

