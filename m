Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44154 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757914Ab2IGJNE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 05:13:04 -0400
Message-ID: <5049BA99.1060707@openwrt.org> (sfid-20120907_111308_829047_C4F0D6AB)
Date: Fri, 07 Sep 2012 11:12:57 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, backports@vger.kernel.org
Subject: Re: [PATCH] compat: drop const to fix compiler warnings
References: <1347004574-80506-1-git-send-email-nbd@openwrt.org> <CAB=NE6V6vAdsVQyjKyaMYnPRQdJLc+Gt=nqiS5cN9mWU3vz7aQ@mail.gmail.com>
In-Reply-To: <CAB=NE6V6vAdsVQyjKyaMYnPRQdJLc+Gt=nqiS5cN9mWU3vz7aQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-09-07 11:04 AM, Luis R. Rodriguez wrote:
> On Fri, Sep 7, 2012 at 12:56 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> When calling pci_find_capability and pci_read_config_word, struct pci_dev
>> needs to be passed without const.
> 
> Thanks! I guess because at certain kernel version pci_dev was const ?
Probably, I didn't really check. Either way, this patch should be safe
for all kernel versions.

- Felix

