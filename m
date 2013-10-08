Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:54971 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab3JHPAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 11:00:54 -0400
Received: by mail-ob0-f182.google.com with SMTP id wn1so571793obc.27
        for <linux-wireless@vger.kernel.org>; Tue, 08 Oct 2013 08:00:54 -0700 (PDT)
Message-ID: <52541E22.2040904@lwfinger.net> (sfid-20131008_170058_232235_C15FFC5F)
Date: Tue, 08 Oct 2013 10:00:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: dwmw2@infradead.org, Ben Hutchings <ben@decadent.org.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Add new firmware files for rtl8192cu
References: <1380234392-31062-1-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1380234392-31062-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/26/2013 05:26 PM, Larry Finger wrote:
> The vendor driver rtl8188C_8192C_8192D_usb_linux_v3.4.2_3727.20120404
> includes new firmware files. These were extracted from data statements
> in that driver to form these files.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>   WHENCE                       |   3 +++
>   rtlwifi/rtl8192cufw_A.bin    | Bin 0 -> 16116 bytes
>   rtlwifi/rtl8192cufw_B.bin    | Bin 0 -> 16096 bytes
>   rtlwifi/rtl8192cufw_TMSC.bin | Bin 0 -> 16116 bytes
>   4 files changed, 3 insertions(+)
>   create mode 100644 rtlwifi/rtl8192cufw_A.bin
>   create mode 100644 rtlwifi/rtl8192cufw_B.bin
>   create mode 100644 rtlwifi/rtl8192cufw_TMSC.bin

I understand that you probably have too much to do, but I am inquiring about the 
status of this submission and "[PATCH] rtlwifi: Add new firmware files for 
rtl8188eu" that I sent on 09/27/2013. I have several patches that depend on 
these firmware files, and I would prefer that those driver patches are submitted 
in time to make the 3.13 kernel.

Thanks,

Larry


