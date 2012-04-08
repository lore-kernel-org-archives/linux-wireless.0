Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43994 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab2DHRww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2012 13:52:52 -0400
Received: by iagz16 with SMTP id z16so5047243iag.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Apr 2012 10:52:52 -0700 (PDT)
Message-ID: <4F81D06E.4010205@lwfinger.net> (sfid-20120408_195322_992552_08AC8354)
Date: Sun, 08 Apr 2012 12:52:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
CC: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] rtlwifi: ID for Belkin Surf N300 XR
References: <CAA2SeN+7FsyQKmCK62tzEzrHLVi6-H21wZ+bdTjS2rLDDdauCA@mail.gmail.com> <4F81C0D4.2090004@lwfinger.net> <CAA2SeNKEFDtciKU29Lwi5kJYy5eaVeFb6cJg33T4QKP2=oCdSA@mail.gmail.com>
In-Reply-To: <CAA2SeNKEFDtciKU29Lwi5kJYy5eaVeFb6cJg33T4QKP2=oCdSA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/08/2012 12:37 PM, Lorenzo Bianconi wrote:
>
> My device is F9L1004az. lsusb reports just Vendor and Product ID. I
> suppose the device is 8192CU because Windows driver is rtl8192cu.
>
> I will rewrite the patch respecting the numerical order

Driver rtl8192cu is used for both RTL8192CU and RTL8188CU; however, in the 
absence of any other info, putting the new device in the 8192CU table will be OK.

Thanks,

Larry

