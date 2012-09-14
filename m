Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:54202 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182Ab2INGLD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 02:11:03 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Julian Calaby <julian.calaby@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	chaoming_li@realsil.com.cn
Subject: Re: [RFC/RFT 14/15] rtlwifi: Modify files for addition of rtl8723ae
References: <1347483294-6943-1-git-send-email-Larry.Finger@lwfinger.net>
	<1347483294-6943-15-git-send-email-Larry.Finger@lwfinger.net>
	<CAGRGNgWezEzXV0-k6DA7TckNpa=zgN6LNv898N-PRU6P1LYgOw@mail.gmail.com>
	<505170C6.8090003@lwfinger.net>
Date: Fri, 14 Sep 2012 09:10:56 +0300
In-Reply-To: <505170C6.8090003@lwfinger.net> (Larry Finger's message of "Thu,
	13 Sep 2012 00:36:06 -0500")
Message-ID: <87mx0t3zin.fsf@purkki.adurom.net> (sfid-20120914_081109_373157_FB26680E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

>> Is this supposed to be bit #29 - I notice that COMP_USB is also bit 29.
>
> Yes, that is OK. One will only be used for PCI-based drivers, and the
> other is obviously for USB. As nearly all the bits of a 32-bit
> quantity are used, I wanted to save one if possible.
>
> In the final version, I'll code this as
>
> #define COMP_USB                       BIT(29)
> #define COMP_EASY_CONCURRENT           COMP_USB
>
> That way will be more obvious.

You could also add a comment explaining it, just to make sure that
everyone understands it.

-- 
Kalle Valo
