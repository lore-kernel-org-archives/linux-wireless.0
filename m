Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1466 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129Ab2EHMkO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 08:40:14 -0400
Message-ID: <4FA9141B.3020008@broadcom.com> (sfid-20120508_144020_104588_C64F0962)
Date: Tue, 8 May 2012 14:39:55 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/19] brcmsmac: use sprom and PCIe code from bcma
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
 <4F9CF839.1040401@broadcom.com> <4FA0CF03.9060307@broadcom.com>
 <4FA1B66A.4060901@hauke-m.de>
In-Reply-To: <4FA1B66A.4060901@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/03/2012 12:34 AM, Hauke Mehrtens wrote:
> Hi Arend,
> 
> thanks for testing.
> 
> Have you tried suspend/resume and hibernate/resume? I think some of the
> workaround in drivers/bcma/driver_pci.c should be called in the resume
> path and not only in the initialization path.
> 
> Hauke
> 

Hi Hauke,

The patches have been in regression testing here for a couple of nights
without issue. Tested chips: bcm43224 and bcm4313. platforms: x86,
x86_64 and ppc64.

I also did a suspend/resume test performing 10 cycles. Have to look in
the logs to get more info. Not tried hibernate/resume testing yet.

Gr. AvS

