Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26592 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752151AbdKNUEY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 15:04:24 -0500
Message-ID: <1510689850.4011.96.camel@intel.com> (sfid-20171114_210431_983071_A2DC292D)
Subject: Re: iwlwifi 8265 firmware crash vith v34 on linux 4.14
From: Luciano Coelho <luciano.coelho@intel.com>
To: Thomas Backlund <tmb@mageia.org>, linux-wireless@vger.kernel.org
Date: Tue, 14 Nov 2017 22:04:10 +0200
In-Reply-To: <b533ecc1-c4ce-b0fc-b7fb-b7beceb1f1cf@mageia.org>
References: <b533ecc1-c4ce-b0fc-b7fb-b7beceb1f1cf@mageia.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Thomas,

On Tue, 2017-11-14 at 21:49 +0200, Thomas Backlund wrote:
> Running a Lenovo Yoga 720 with kernel 4.14, I pulled the:
> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-
> firmware.git 
> tags/iwlwifi-fw-2017-11-03
> 
> to try the new fw version 34 on my:
> 3f:00.0 Network controller [0280]: Intel Corporation Wireless 8265 / 
> 8275 [8086:24fd] (rev 78)
> 
> And got this firmware crash and no wifi working:
> (for reference firmware version 31.560484.0 from same git pull works)
> 
> 
> [   11.423208] iwlwifi 0000:3f:00.0: Error sending SCAN_REQ_UMAC:
> time out after 2000ms.

Yes, this was a screw up on my side regarding the FW API.  We have a
bugzilla and a patch to fix it already (on my comment #6):

https://bugzilla.kernel.org/show_bug.cgi?id=197591#c6

I'll try to get this into the first stable release for 4.14.

Sorry for the trouble and thanks for reporting!

--
Cheers,
Luca.
