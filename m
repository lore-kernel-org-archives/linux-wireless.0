Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:43806 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbZHUMNP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 08:13:15 -0400
Received: by rv-out-0506.google.com with SMTP id f6so242548rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 05:13:16 -0700 (PDT)
Message-ID: <4A8E8F59.9050706@lwfinger.net>
Date: Fri, 21 Aug 2009 07:13:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: feng tian <feng.of.tian@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Abour linux driver supports BCM4325
References: <f42a38140908202319y5c352aa3s37fec67e5cb8d7a3@mail.gmail.com>
In-Reply-To: <f42a38140908202319y5c352aa3s37fec67e5cb8d7a3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

feng tian wrote:
> Dear All,
> 
> We are working on a project which supports the BCM4325 linux wireless
> driver. The interface between the BCM chip and SOC(pxa310) is SDIO.
> I did some searches online and found that there is no available driver
> for this chip. Do I have to implement this myself? Is there anyone can
> provide us some related materials?  Thanks very much.

The code for the LP PHY, which I believe is present in the 4325, is
just being written. At the moment, the chip is able to receive on some
channels, and may be able to transmit. These results are reported on
this mailing list, and the code is being applied to the wireless
testing git tree.

Larry
