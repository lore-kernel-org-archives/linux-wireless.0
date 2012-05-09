Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50347 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758842Ab2EIJAj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 05:00:39 -0400
Message-ID: <4FAA322C.1070303@hauke-m.de> (sfid-20120509_110043_404191_20DE9DDE)
Date: Wed, 09 May 2012 11:00:28 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/19] brcmsmac: use sprom and PCIe code from bcma
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de> <4F9CF839.1040401@broadcom.com> <4FA0CF03.9060307@broadcom.com> <4FA1B66A.4060901@hauke-m.de> <4FA9141B.3020008@broadcom.com>
In-Reply-To: <4FA9141B.3020008@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/08/2012 02:39 PM, Arend van Spriel wrote:
> On 05/03/2012 12:34 AM, Hauke Mehrtens wrote:
>> Hi Arend,
>>
>> thanks for testing.
>>
>> Have you tried suspend/resume and hibernate/resume? I think some of the
>> workaround in drivers/bcma/driver_pci.c should be called in the resume
>> path and not only in the initialization path.
>>
>> Hauke
>>
> 
> Hi Hauke,
> 
> The patches have been in regression testing here for a couple of nights
> without issue. Tested chips: bcm43224 and bcm4313. platforms: x86,
> x86_64 and ppc64.
> 
> I also did a suspend/resume test performing 10 cycles. Have to look in
> the logs to get more info. Not tried hibernate/resume testing yet.
> 
> Gr. AvS
> 
Hi Arend,

I would like to see these patches in kernel 3.5. John said that stuff
for that release has to be posted now. Could you look into the
suspend/resume log today and give an Ack for the patches if it works?
You tested the two patch series for bcma and the patches for brcmsmac
all together?

Hauke
