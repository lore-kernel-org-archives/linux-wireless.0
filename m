Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:46124 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZKHMlp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 07:41:45 -0500
Received: by ewy3 with SMTP id 3so2346758ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 04:41:50 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: Mark rt2800pci as broken.
Date: Sun, 8 Nov 2009 13:38:34 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <1257679734-25160-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1257679734-25160-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Message-Id: <200911081338.34697.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


[ please cc: me on rt2x00 patches if possible, thanks ]

On Sunday 08 November 2009 12:28:54 Gertjan van Wingerde wrote:
> The rt2800pci driver is currently only marked as experimental, and only the help text explains that
> the driver is basically non-functional. Make the driver depend on CONFIG_BROKEN so that users cannot
> enable this driver without knowing that it is broken.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

> @@ -78,9 +78,6 @@ config RT2800PCI
>  	  This adds support for rt2800 wireless chipset family.
>  	  Supported chips: RT2760, RT2790, RT2860, RT2880, RT2890 & RT3052
>  
> -	  This driver is non-functional at the moment and is intended for
> -	  developers.
> -
>  	  When compiled as a module, this driver will be called "rt2800pci.ko".
>  
>  config RT2500USB

This help text could have stayed, anyway..

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

[ This is against rt2800 tree right?  Cause I don't see any of my patches
  in public rt2x00 tree yet. ]

--
Bartlomiej Zolnierkiewicz
