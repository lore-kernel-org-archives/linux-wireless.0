Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63740 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab1EFNCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 09:02:43 -0400
Received: by bwz15 with SMTP id 15so2485133bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 06:02:42 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Andrew V. Stepanov" <stanv@altlinux.org>
Subject: Re: carl9170.ko RX - DMA, TX - COPY
Date: Fri, 6 May 2011 15:02:25 +0200
Cc: linux-wireless@vger.kernel.org
References: <BANLkTiniamP_zXeGkW2TgatdkSv1+rdfeg@mail.gmail.com> <201105042209.29950.chunkeey@googlemail.com> <BANLkTinH2pU2mGnoN1=BMQkY-0mhN801+A@mail.gmail.com>
In-Reply-To: <BANLkTinH2pU2mGnoN1=BMQkY-0mhN801+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201105061502.25981.chunkeey@googlemail.com> (sfid-20110506_150246_634919_8A4799BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 May 2011 14:13:39 Andrew V. Stepanov wrote:
> What is:
> 
>  ar->fw.tx_stream = true;
> 
What about it? it's a configurable feature. It can be used to 
upload several frames in one urb-[tansfer], but I never looked into
usb sg and it wasn't enabled in the original vendor driver either.

Currently, It just adds another 4 byte [tag + len] to the headroom so
it won't make a difference in your case anyway...

Regards,
	Christian
