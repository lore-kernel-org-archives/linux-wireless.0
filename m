Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:61416 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762805Ab3DHQ2d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 12:28:33 -0400
Received: by mail-ob0-f175.google.com with SMTP id va7so6045209obc.34
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 09:28:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P3Mt3X8JXq5siSijrWGkjeWbTCcdmJ-Fuv6U8jUqrFouQ@mail.gmail.com>
References: <CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com>
 <20130304134949.GB3021@redhat.com> <CANUX_P0JhuVWcQjTckYzG8eBb2MtT_=prKqV38mCpVjfLmGtCA@mail.gmail.com>
 <20130304154832.GD3021@redhat.com> <CANUX_P22AkqeOROP1QHzp20wGWgDbRzy+9FZy2KvHLXCQ5AVnA@mail.gmail.com>
 <CAErSpo5gVsUxB6ebQGAN-7jsZiRYZ+SyJn5gKZrSuOzzkJ-QjQ@mail.gmail.com>
 <CANUX_P2-V0-=sfofxYwAYCRvqPPf5Z2wy6CUNQmGQQ2NqjZJ_A@mail.gmail.com>
 <CAErSpo4xmDU2O35ge342nMuiVyDkzSGNRaz2O7-w6jDz_eBgyg@mail.gmail.com>
 <CANUX_P2Hy02SnyYS24dyUGLv3wB3L5xkXt8Y1s+8_RG9d5ReAw@mail.gmail.com>
 <CANUX_P3znXgMN5aBZbEVx_zKpTQ98my1C_cBG5+mERFWrrrLEw@mail.gmail.com> <CANUX_P3Mt3X8JXq5siSijrWGkjeWbTCcdmJ-Fuv6U8jUqrFouQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 8 Apr 2013 10:28:13 -0600
Message-ID: <CAErSpo66=UngrHNcEDeh4gXnt5c0qJHwbxum0mBz-rSWGduLhg@mail.gmail.com> (sfid-20130408_182853_521254_6DBD8318)
Subject: Re: is L1 really disabled in iwlwifi
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Roman Yepishev <roman.yepishev@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 On Sun, Apr 7, 2013 at 6:23 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>>
>>> I attached all the data you needed.
>>> The link state seems to go to L1 based on the low power the NIC consumes.
>>> So it seems that even if we use pci_disable_link_state() to disabled
>>> L1, L1 is still disabled.
>>>
>>
>> Ugh... so doesn't make any sense.... so again:
>>
>> So it seems that even if we use pci_disable_link_state() to disable
>> L1, the link state still enters L1.
>
> ping? :-)

Sorry, I haven't had a chance to look at this yet.  Can you please
attach the *complete* dmesg and lspci output, not just the parts that
mention iwlwifi?  Some of this depends on other PCI core stuff, like
what happened with the _OSC evaluation when we discovered the PCI host
bridge.

Bjorn
