Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:31476 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbYGWV4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 17:56:40 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3076914wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 14:56:40 -0700 (PDT)
Message-ID: <1ba2fa240807231456y2fce119ek1bd03ad9d250fee5@mail.gmail.com> (sfid-20080723_235643_632085_E9DEF284)
Date: Thu, 24 Jul 2008 00:56:39 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: denys@visp.net.lb
Subject: Re: 2.6.26-git10 compile error, iwl-led.c
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200807240049.29021.denys@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200807240049.29021.denys@visp.net.lb>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 24, 2008 at 12:49 AM,  <denys@visp.net.lb> wrote:
> sunfire-1 linux-2.6.26 # sunfire-1 globalosii # cp globalfs1 globalfs
> sunfire-1 linux-2.6.26 # make
>  CHK     include/linux/version.h
>  CHK     include/linux/utsrelease.h
>  CALL    scripts/checksyscalls.sh
>  CHK     include/linux/compile.h
> dnsdomainname: Unknown host
>  GEN     usr/initramfs_data.cpio.gz
>  AS      usr/initramfs_data.o
>  LD      usr/built-in.o
>  LD [M]  drivers/net/wireless/rtl8187.o
>  CC [M]  drivers/net/wireless/iwlwifi/iwl-led.o
> drivers/net/wireless/iwlwifi/iwl-led.c: In function 'iwl_led_brightness_set':
> drivers/net/wireless/iwlwifi/iwl-led.c:198: error: 'led_type_str' undeclared (first use in this function)
> drivers/net/wireless/iwlwifi/iwl-led.c:198: error: (Each undeclared identifier is reported only once
> drivers/net/wireless/iwlwifi/iwl-led.c:198: error: for each function it appears in.)
> make[4]: *** [drivers/net/wireless/iwlwifi/iwl-led.o] Error 1
> make[3]: *** [drivers/net/wireless/iwlwifi] Error 2
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Patches were posted twice already
Tomas
