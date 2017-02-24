Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36896 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdBXISQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 03:18:16 -0500
Received: by mail-wm0-f49.google.com with SMTP id v77so8571207wmv.0
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2017 00:16:47 -0800 (PST)
Subject: Re: brcmfmac: problem using WPS with wpa_supplicant on BCM43362
To: =?UTF-8?Q?J=c3=b6rg_Krause?= <joerg.krause@embedded.rocks>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1487881302.20481.3.camel@embedded.rocks>
Cc: brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <dd241eff-7e0d-26c1-1758-b3f4d51bc359@broadcom.com> (sfid-20170224_091847_252899_450A6CE7)
Date: Fri, 24 Feb 2017 09:16:44 +0100
MIME-Version: 1.0
In-Reply-To: <1487881302.20481.3.camel@embedded.rocks>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 23-2-2017 21:21, Jörg Krause wrote:
> Hi,
> 
> I am using Linux Kernel v4.9.9 and wpa_supplicant 2.6. When running
> 'wpa_cli wps_pin any', the following messages are printed:
> 
> """
>> wps_pin any         
> [ 4011.779108] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set error : -30
> [ 4011.786190] brcmfmac: brcmf_config_ap_mgmt_ie: Set Beacon IE Failed
> """
> 
> .. and nothing happens. The data sheet for the BCM43362 states that the
> module supports WPS.

Hi Jörg,

We have never tested WPS with brcmfmac. Most of it is in firmware so it
might work. We had some fixes related to setting management IE, but it
should be in 4.9. I did not check it (yet).

Regards,
Arend
