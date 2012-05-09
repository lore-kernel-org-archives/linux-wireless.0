Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52253 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756346Ab2EIW1m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 18:27:42 -0400
Message-ID: <4FAAEF58.3080302@hauke-m.de> (sfid-20120510_002745_627040_1DCD27A9)
Date: Thu, 10 May 2012 00:27:36 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/19] brcmsmac: use sprom and PCIe code from bcma
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de> <4F9CF839.1040401@broadcom.com> <4FA0CF03.9060307@broadcom.com> <4FA1B66A.4060901@hauke-m.de> <4FA9141B.3020008@broadcom.com> <4FAA322C.1070303@hauke-m.de> <4FAA3837.8090401@broadcom.com>
In-Reply-To: <4FAA3837.8090401@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/2012 11:26 AM, Arend van Spriel wrote:
> On 05/09/2012 11:00 AM, Hauke Mehrtens wrote:
>> Hi Arend,
>>
>> I would like to see these patches in kernel 3.5. John said that stuff
>> for that release has to be posted now. Could you look into the
>> suspend/resume log today and give an Ack for the patches if it works?
>> You tested the two patch series for bcma and the patches for brcmsmac
>> all together?
>>
>> Hauke
>>
> 
> I tested with patches from 3 series applied:
> 
> ssb/bcma/bcm47xx: extend boardinfo and sprom
> bcma: add PCI functions from brcmsmac
> brcmsmac: use sprom and PCIe code from bcma

Thanks

> Unfortunately, I am working from home and I did not bring my test
> laptop. I have not very good experience testing suspend/resume over a
> ssh connection. So I can do not do it sooner than tomorrow.

Ok, remote suspend resume testing without a special test environment is
not easily possible.

> Has b43 been tested against these patches on bcma? Also Rafał is still
> the bcma maintainer. Did he Ack the patches already?

I tested bcma and ssb with b43 with the devices I have and have not
found any new problems. Rafał is quite silent in the last months and I
have not heard from him anything about these patches. I just send an
extra mail, hopefully he will answer.

Hauke
