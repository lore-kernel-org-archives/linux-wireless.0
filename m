Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33296 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S979499AbdDYAZm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 20:25:42 -0400
Received: by mail-oi0-f49.google.com with SMTP id y11so122445496oie.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Apr 2017 17:25:42 -0700 (PDT)
Subject: Re: WPA authorization with RTL8723DS
To: Adam Casson <adam.casson@inscopemedical.com>,
        linux-wireless@vger.kernel.org
References: <CAPdsbMvE=_-oQ9wWLPQkUuF_Q3JeHCKo-0NrPt0hRRPo8khH9Q@mail.gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <b5eeb1fc-aea0-1489-ffa4-40b4e1dc1873@lwfinger.net> (sfid-20170425_022547_310922_E382F3D0)
Date: Mon, 24 Apr 2017 19:25:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAPdsbMvE=_-oQ9wWLPQkUuF_Q3JeHCKo-0NrPt0hRRPo8khH9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2017 03:25 PM, Adam Casson wrote:
> I'm trying to build a product around the Next Thing Co CHIP Pro
> (nextthing.co/pages/chippro) and have found that the RTL8723DS wifi/BT
> chip is fairly unstable, particularly when trying to implement WPA
> authorization. A previous version of this SoM uses the RTL8723BS which
> is similar in structure and driver, but this new 8723DS is different
> enough to warrant a separate code branch from both Realtek and the
> manufacturer of the SoM. However, Realtek has not publically released
> a driver for the new 8723DS chip. We have received no support from the
> SoM manufacturer, so we're looking for some external help so that we
> can maybe salvage the considerable work we've put into developing
> around this SoM.
>
> Some additional details about how the device was being used are below.
>
> Use hopstapd (configuration for open and WPA included) to configure
> the Chip Pro as an access point. Launch hostapd (command line also
> provided in logs).
>
> Gadget buildroot git commit e550a93f2b08c771f0dd75919bb042ad86faa763
>
> WPA version 2 (as specified in the provided hostapd config).
>
> Client types tested:
>
> - rtl8188eu usb dongle on Ubuntu 16.04 workstation
> - 2013 Mac Book Pro running 10.12 Sierra
>
> Same results with both (WPA auth failed). Both clients have been
> tested successfully with a wide range of WPA2 access points.
>
> Thanks for any help you can provide!

I was not aware that a 8723D chip had been released. If there is a PCI version 
(8723DE), then there is probably not a Linux driver for it.

Certainly, the 8723D driver would differ from the one for 8723B.

I have written to my contacts at Realtek to see if I can learn what drivers are 
available. I will let you know what I hear.

Larry
