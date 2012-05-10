Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3565 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492Ab2EJMOX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 08:14:23 -0400
Message-ID: <4FABB112.5040900@broadcom.com> (sfid-20120510_141426_499144_C2DCDB81)
Date: Thu, 10 May 2012 14:14:10 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/19] brcmsmac: use sprom and PCIe code from bcma
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
 <4F9CF839.1040401@broadcom.com> <4FA0CF03.9060307@broadcom.com>
 <4FA1B66A.4060901@hauke-m.de> <4FA9141B.3020008@broadcom.com>
 <4FAA322C.1070303@hauke-m.de> <4FAA3837.8090401@broadcom.com>
 <4FAAEF58.3080302@hauke-m.de>
In-Reply-To: <4FAAEF58.3080302@hauke-m.de>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2012 12:27 AM, Hauke Mehrtens wrote:
> On 05/09/2012 11:26 AM, Arend van Spriel wrote:
>> On 05/09/2012 11:00 AM, Hauke Mehrtens wrote:
>>> Hi Arend,
>>>
>>> I would like to see these patches in kernel 3.5. John said that stuff
>>> for that release has to be posted now. Could you look into the
>>> suspend/resume log today and give an Ack for the patches if it works?
>>> You tested the two patch series for bcma and the patches for brcmsmac
>>> all together?
>>>
>>> Hauke
>>>
>>
>> I tested with patches from 3 series applied:
>>
>> ssb/bcma/bcm47xx: extend boardinfo and sprom
>> bcma: add PCI functions from brcmsmac
>> brcmsmac: use sprom and PCIe code from bcma

I performed suspend/resume and hibernate/resume testing for bcm43224
PCIe card. In one run I observed the WARN_ONCE in
brcms_c_wait_for_tx_completion(). Have to dive into that to see what
happens in resume scenario to trigger this. No reason to stop your
patches though.

So for the series listed above:
Tested-by: Arend van Spriel <arend@broadcom.com>

Gr. AvS


