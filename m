Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56340 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760022Ab3DBTMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 15:12:42 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Jonathan McDowell <noodles@earth.li>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: RE: [Ilw] Problems with Intel 2230 and AP mode
Date: Tue, 2 Apr 2013 19:11:12 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301965EC0@HASMSX103.ger.corp.intel.com> (sfid-20130402_211248_309315_8DB94435)
References: <20130402190831.GQ31591@earth.li>
In-Reply-To: <20130402190831.GQ31591@earth.li>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> I'm trying to build my own wifi router, cobbling together a Debian
> (wheezy) box, hostapd (1.0) and an Intel 2230. I'm seeing various
> problems with the 2230 and I'm wondering if I'm mad for trying to use
> this card in AP mode (in which case is there an alternative Intel card I
> should use, or is an ath9k my best bet), or if it's worthwhile reporting
> the issues and trying fixes.
> 
> I'm using 3.8.5 (and previously 3.8.4). I tried 3.9-rc4 briefly but it
> was unusable - as soon as there was any traffic I saw errors like:
> 
> Mar 27 19:33:51 ramen kernel: [ 7687.814137] iwlwifi 0000:04:00.0: Stopping
> AGG while state not ON or starting for 3 on 0 (4)
> Mar 27 19:33:51 ramen kernel: [ 7687.818846] iwlwifi 0000:04:00.0: txq_id
> mismatch: 11 0
> Mar 27 19:33:51 ramen kernel: [ 7687.818899] iwlwifi 0000:04:00.0: txq_id
> mismatch: 11 0
> Mar 27 19:33:51 ramen kernel: [ 7687.818946] iwlwifi 0000:04:00.0: txq_id
> mismatch: 11 0
> Mar 27 19:33:51 ramen kernel: [ 7687.818993] iwlwifi 0000:04:00.0: txq_id
> mismatch: 11 0
> Mar 27 19:33:51 ramen kernel: [ 7687.819039] iwlwifi 0000:04:00.0: txq_id
> mismatch: 11 0
> Mar 27 19:33:51 ramen kernel: [ 7687.819085] iwlwifi 0000:04:00.0: txq_id
> mismatch: 11 0

Can you please try with debug=0x80000000 and send the output of it?
---------------------------------------------------------------------
A member of the Intel Corporation group of companies

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

