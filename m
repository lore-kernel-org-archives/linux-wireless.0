Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4247 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab2EIJ0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 05:26:31 -0400
Message-ID: <4FAA3837.8090401@broadcom.com> (sfid-20120509_112634_831691_00DFE274)
Date: Wed, 9 May 2012 11:26:15 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/19] brcmsmac: use sprom and PCIe code from bcma
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
 <4F9CF839.1040401@broadcom.com> <4FA0CF03.9060307@broadcom.com>
 <4FA1B66A.4060901@hauke-m.de> <4FA9141B.3020008@broadcom.com>
 <4FAA322C.1070303@hauke-m.de>
In-Reply-To: <4FAA322C.1070303@hauke-m.de>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/2012 11:00 AM, Hauke Mehrtens wrote:
> Hi Arend,
> 
> I would like to see these patches in kernel 3.5. John said that stuff
> for that release has to be posted now. Could you look into the
> suspend/resume log today and give an Ack for the patches if it works?
> You tested the two patch series for bcma and the patches for brcmsmac
> all together?
> 
> Hauke
> 

I tested with patches from 3 series applied:

ssb/bcma/bcm47xx: extend boardinfo and sprom
bcma: add PCI functions from brcmsmac
brcmsmac: use sprom and PCIe code from bcma

Unfortunately, I am working from home and I did not bring my test
laptop. I have not very good experience testing suspend/resume over a
ssh connection. So I can do not do it sooner than tomorrow.

Has b43 been tested against these patches on bcma? Also Rafał is still
the bcma maintainer. Did he Ack the patches already?

Gr. AvS

