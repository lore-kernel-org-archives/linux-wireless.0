Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:56808 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbZIIIBY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2009 04:01:24 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MlI7I-00009H-HU
	for linux-wireless@vger.kernel.org; Wed, 09 Sep 2009 10:01:24 +0200
Received: from cpc1-cmbg9-0-0-cust9.cmbg.cable.ntl.com ([82.16.96.10])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2009 10:01:24 +0200
Received: from jon.fairbairn by cpc1-cmbg9-0-0-cust9.cmbg.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2009 10:01:24 +0200
To: linux-wireless@vger.kernel.org
From: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Subject: Re: AP: ath5k + hostapd occasionally sulks
Date: Wed, 09 Sep 2009 09:01:09 +0100
Message-ID: <wf4orcpmwq.fsf@calligramme.charmers>
References: <4AA69A0D.3040608@redfish-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Philip Prindeville
<philipp_subx@redfish-solutions.com> writes:

> I pulled compat-wireless from GIT last night (or about 1:30am mountain,
> really) and rebuilt a 2.6.27.29 kernel.
>
> I'm seeing a lot of:
>
> Sep  8 11:44:09 pbx user.err kernel: ath5k phy0: no further txbuf available, dropping packet

> Is this a known issue? Jon posted the same question, but I didn't see an
> answer to his question...

Most of the time it works and I don't see anything in the logs, so your
problem is worse than mine... I'm now running
compat-wireless-2009-09-07, but I doubt if that's any different.
-- 
Jón Fairbairn                                 Jon.Fairbairn@cl.cam.ac.uk

