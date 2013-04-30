Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34578 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab3D3K5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Apr 2013 06:57:14 -0400
MIME-Version: 1.0
In-Reply-To: <CANUX_P0hpx8NNvX6cJXfOZMNYN8hrEF-gzf9hBN2Uz=k0WiwgA@mail.gmail.com>
References: <CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com>
	<20130304134949.GB3021@redhat.com>
	<CANUX_P0JhuVWcQjTckYzG8eBb2MtT_=prKqV38mCpVjfLmGtCA@mail.gmail.com>
	<20130304154832.GD3021@redhat.com>
	<CANUX_P22AkqeOROP1QHzp20wGWgDbRzy+9FZy2KvHLXCQ5AVnA@mail.gmail.com>
	<CAErSpo5gVsUxB6ebQGAN-7jsZiRYZ+SyJn5gKZrSuOzzkJ-QjQ@mail.gmail.com>
	<CANUX_P2-V0-=sfofxYwAYCRvqPPf5Z2wy6CUNQmGQQ2NqjZJ_A@mail.gmail.com>
	<CAErSpo4xmDU2O35ge342nMuiVyDkzSGNRaz2O7-w6jDz_eBgyg@mail.gmail.com>
	<CANUX_P2Hy02SnyYS24dyUGLv3wB3L5xkXt8Y1s+8_RG9d5ReAw@mail.gmail.com>
	<CANUX_P3znXgMN5aBZbEVx_zKpTQ98my1C_cBG5+mERFWrrrLEw@mail.gmail.com>
	<CANUX_P3Mt3X8JXq5siSijrWGkjeWbTCcdmJ-Fuv6U8jUqrFouQ@mail.gmail.com>
	<CAErSpo66=UngrHNcEDeh4gXnt5c0qJHwbxum0mBz-rSWGduLhg@mail.gmail.com>
	<CANUX_P0hpx8NNvX6cJXfOZMNYN8hrEF-gzf9hBN2Uz=k0WiwgA@mail.gmail.com>
Date: Tue, 30 Apr 2013 13:57:12 +0300
Message-ID: <CANUX_P1JnFk7yovC7kXBMDWiErGhvzDQrNCm8te39m41SonCNg@mail.gmail.com> (sfid-20130430_125725_909433_EF7979CC)
Subject: Re: is L1 really disabled in iwlwifi
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Roman Yepishev <roman.yepishev@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
>> Sorry, I haven't had a chance to look at this yet.  Can you please
>> attach the *complete* dmesg and lspci output, not just the parts that
>> mention iwlwifi?  Some of this depends on other PCI core stuff, like
>> what happened with the _OSC evaluation when we discovered the PCI host
>> bridge.
>>
>
> Here is the info you wanted. Same config file as before.
> Note that I now have two WiFi NICs connected.

Any chance you'll find time for me? :-)
