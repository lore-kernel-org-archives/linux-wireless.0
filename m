Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28909 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756886AbdHYOxM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Aug 2017 10:53:12 -0400
Subject: Re: [PATCH 2/2] brcmfmac: Use separate firmware for revision 0 of the
 brcm43430 chip
To: =?UTF-8?Q?J=c3=b6rg_Krause?= <joerg.krause@embedded.rocks>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Jelle van der Waa <jelle@vdwaa.nl>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
References: <20170616131449.12108-1-hdegoede@redhat.com>
 <20170616131449.12108-2-hdegoede@redhat.com>
 <1503669327.8480.3.camel@embedded.rocks>
 <c851671c-1147-94cc-cf98-d0b20b051b3b@redhat.com>
 <1503672591.22413.3.camel@embedded.rocks>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <63fa22df-4268-12b9-9b4d-c60235130dde@redhat.com> (sfid-20170825_165338_641546_991053E9)
Date: Fri, 25 Aug 2017 16:53:08 +0200
MIME-Version: 1.0
In-Reply-To: <1503672591.22413.3.camel@embedded.rocks>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 25-08-17 16:49, Jörg Krause wrote:

<snip>

> Thanks for the files!
> 
> I've tested with brcmfmac43430a0-sdio.bin.7.10.1.244.ucode940.1020 and
> brcmfmac is happy:
> 
> brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Jul  1 2016
> 18:02:40 version 7.10.1 (A0 Station/P2P feature) FWID 01-bae8afee
> 
> Where did you got the firmware files from?

 From various Android x86 images and from:
https://android.googlesource.com/platform/hardware/broadcom/wlan/+/master/bcmdhd/firmware/

Regards,

Hans
