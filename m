Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:48566 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbaA0TK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 14:10:58 -0500
Received: by mail-qc0-f179.google.com with SMTP id e16so8818615qcx.10
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jan 2014 11:10:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52826A82.3010505@broadcom.com>
References: <52821B80.6000305@gmail.com>
	<52826A82.3010505@broadcom.com>
Date: Mon, 27 Jan 2014 11:10:57 -0800
Message-ID: <CAJ-Vmo=LtKsGPbvjQ01VQSad-vKCkq5usRaGcD-WdZPcnG7SrQ@mail.gmail.com> (sfid-20140127_201102_774887_E727218B)
Subject: Re: Trying to add support of 802.11ac broadcom chpiset to openwrt
From: Adrian Chadd <adrian@freebsd.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Alessandro Gnagni <enterprise.nx@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 November 2013 09:50, Arend van Spriel <arend@broadcom.com> wrote:
> On 11/12/2013 01:13 PM, Alessandro Gnagni wrote:
>>
>> Hi,
>> i am trying to implement on a smart city network a solution based on
>> high end home routers like the asus RT-AC66U.
>> we want to use openwrt for that but unfortunately the broadcom driver
>> isn't yet supported.
>> I have one rt-ac66u here for development, there is anything that i can
>> do for help?
>> i came here after a suggestion of one member on openwrt forum:
>> https://forum.openwrt.org/viewtopic.php?pid=217341#p217341
>>
>> i also read this past email:
>> http://www.spinics.net/lists/linux-wireless/msg110443.html
>
>
> Not sure what 11ac chipset is used. The upstream brcm80211 drivers currently
> only support one 11ac chipset, ie. the bcm4335. This is a single stream with
> SDIO host interface supported by the fullmac driver brcmfmac.
>
> For chipsets like 4360 we need to add AC phy support to brcmsmac. So far we
> do not have green light to do so.
>
> Regards,
> Arend

Hiya,

Is this still the status quo? I'd like to start porting updated
broadcom support to FreeBSD for Apple Macintosh users who would like
11ac NIC support.


-a
