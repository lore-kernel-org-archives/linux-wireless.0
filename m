Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:32872 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751325AbdGQUOX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 16:14:23 -0400
Subject: Re: [PATCH 01/11] rtlwifi: rtl8192de: constify pci_device_id.
To: Arvind Yadav <arvind.yadav.cs@gmail.com>,
        chaoming_li@realsil.com.cn, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1500314995-3181-1-git-send-email-arvind.yadav.cs@gmail.com>
 <1500314995-3181-2-git-send-email-arvind.yadav.cs@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <452c5c19-b931-624e-72e4-124079b903ef@lwfinger.net> (sfid-20170717_221443_321312_B72B60AA)
Date: Mon, 17 Jul 2017 15:14:20 -0500
MIME-Version: 1.0
In-Reply-To: <1500314995-3181-2-git-send-email-arvind.yadav.cs@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/17/2017 01:09 PM, Arvind Yadav wrote:
> pci_device_id are not supposed to change at runtime. All functions
> working with pci_device_id provided by <linux/pci.h> work with
> const pci_device_id. So mark the non-const structs as const.
> 
> File size before:
>     text	   data	    bss	    dec	    hex	filename
>     2833	    945	     12	   3790	    ece realtek/rtlwifi/rtl8192de/sw.o
> 
> File size After adding 'const':
>     text	   data	    bss	    dec	    hex	filename
>     2929	    849	     12	   3790	    ece realtek/rtlwifi/rtl8192de/sw.o
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

This applies to all 11.

Thanks,

Larry
