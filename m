Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:20880 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab3JMEtj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Oct 2013 00:49:39 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Ben Meiselman <benmeiselman@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Seth Forshee (seth.forshee@canonical.com)"
	<seth.forshee@canonical.com>
CC: Yonah Meiselman <yonah.meiselman@gmail.com>
Subject: RE: [Ilw] trouble with wireless AC 7260 in ubuntu 13.04
Date: Sun, 13 Oct 2013 04:49:27 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301DC1C5A@HASMSX103.ger.corp.intel.com> (sfid-20131013_064943_499387_031CE641)
References: <CAHpj=KC=eRafrM4+bxO+nGg4UBCkV1toyei4HL_s+Svd_3BrtA@mail.gmail.com>
In-Reply-To: <CAHpj=KC=eRafrM4+bxO+nGg4UBCkV1toyei4HL_s+Svd_3BrtA@mail.gmail.com>
Content-Type: text/plain; charset="windows-1255"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

First, please note that mails in any other format than plaintext won't go through the filters to the mailing list. So please, hit the plain text button in gmail.


> Hello supporters,

:) 

> I got your email addresses from here: http://wireless.kernel.org/en/users/Drivers/iwlwifi
> (Also copying my brother on this email.)

> I installed Ubuntu 13.04 on a new machine. It has an Intel Dual Band AC 7260 wireless card. I would like to connect to a wireless network but don't know how.
> I put iwlwifi-7260-7.ucode into /lib/firmware

I am not sure if Ubuntu 13.04 supports this new device already. I'd ask Seth Forshee (CCed).
This device is supported starting from kernel 3.10 which AFAIK is not shipped with Ubuntu 13.04. They may very well have added a backport based driver.

Can you please send the output of modinfo iwlmvm?
I also would like to see the output of dmesg.


>   *-network UNCLAIMED
>       description: Network controller
>    product: Intel Corporation
>      vendor: Intel Corporation
>       physical id: 0
>       bus info: pci@0000:03:00.0
>       version: 73
>       width: 64 bits
>       clock: 33MHz
>       capabilities: pm msi pciexpress bus_master cap_list
>       configuration: latency=0
>       resources: memory:f7c00000-f7c01fff


