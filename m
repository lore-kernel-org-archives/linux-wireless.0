Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:36711 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbbFAMca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 08:32:30 -0400
Received: by igbpi8 with SMTP id pi8so59756774igb.1
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 05:32:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <556C490E.90509@broadcom.com>
References: <1432815561-6639-1-git-send-email-zajec5@gmail.com>
	<556C490E.90509@broadcom.com>
Date: Mon, 1 Jun 2015 14:32:29 +0200
Message-ID: <CACna6rzYYwm-bSxGGUofB9pVC=9dtVtuTfotGpFiwsVfxh=Wew@mail.gmail.com> (sfid-20150601_143233_836782_5C205912)
Subject: Re: [PATCH] brcmfmac: support NVRAMs containing pci devpaths (instead
 of pcie)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 June 2015 at 13:59, Arend van Spriel <arend@broadcom.com> wrote:
> On 05/28/15 14:19, Rafał Miłecki wrote:
>>
>> Recently Broadcom added support for NVRAMs with entries for multiple
>> PCIe devices. One of the supported formats is based on prefixes defined
>> like: devpath0=pcie/1/4/ and entries like 0:foo=bar 0:baz=qux etc.
>>
>> Unfortunately there are also a bit older devices using different way of
>> defining prefixes, e.g. SmartRG SR400ac (2 x BCM43602) with entries:
>> devpath0=pci/1/1/
>> devpath1=pci/2/1
>> Broadcom stated this old format will never be used/supported by brcmfmac
>> but given the simplicity of this patch I'll insist on supporting it.
>
>
> Well, if you insist :-p
>
> Acked-by: Arend van Spriel <arend@broadcom.com>

Haha, thanks :) This will make SR400ac my primary home router for
sure. A great piece of hardware :)

-- 
Rafał
