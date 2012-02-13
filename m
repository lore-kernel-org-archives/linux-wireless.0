Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49936 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab2BMEbg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Feb 2012 23:31:36 -0500
Received: by iacb35 with SMTP id b35so3704535iac.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Feb 2012 20:31:35 -0800 (PST)
Message-ID: <4F389224.9010502@lwfinger.net> (sfid-20120213_053156_666384_0EA4D731)
Date: Sun, 12 Feb 2012 22:31:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Prashant Badsheshi <prashant.badsheshi@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regarding Realtek wifi RTL8192
References: <CA+cdTWYUQrM3s-0VL3_H-FWo=BvOQLhr-a_ZH5sSPvsBRmtxKg@mail.gmail.com> <4F388424.8050100@lwfinger.net> <CA+cdTWbaLzZ0vcdyW5bhrQ9=9h1tkbSMu_eBTQcfjEj2UEBEiA@mail.gmail.com>
In-Reply-To: <CA+cdTWbaLzZ0vcdyW5bhrQ9=9h1tkbSMu_eBTQcfjEj2UEBEiA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/12/2012 09:42 PM, Prashant Badsheshi wrote:
> Dear Larry,
>
> Is the wireless chip used in the RTL8192CE and RTL8192SE are same or different?
> What is the difference bwtween RTL8192CE and RTL8192SE?
> Please let me know what do you mean by S in RTL8192SE?

Please do not drop the wireless ML - I do not do private consulting unless you 
are paying me.

You should have figured out that those two chips are not the same. After all, 
they have different drivers.

There are C chips and S chips. They are different. You need to contact Realtek 
to find out about the differences. The only thing I know is that the C chips are 
single stream, but the S version comes in 1x1, 1x2, and 2x2 variants - at least 
for the PCI form.


