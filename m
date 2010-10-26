Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53443 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655Ab0JZSYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 14:24:49 -0400
Received: by fxm16 with SMTP id 16so4393245fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 11:24:48 -0700 (PDT)
Message-ID: <4CC71CFF.8050004@lwfinger.net>
Date: Tue, 26 Oct 2010 13:25:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: seno <senada@t-online.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187b: do not do per packet TX AGC
References: <1282974868-22237-1-git-send-email-cascardo@holoscopio.com> <4C798080.8010002@lwfinger.net> <20100830141218.GB30864@tuxdriver.com> <4C7BC4D9.1010108@lwfinger.net> <20100830152841.GB2950@barata.holoscopio.com> <loom.20101026T200014-691@post.gmane.org>
In-Reply-To: <loom.20101026T200014-691@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/2010 01:03 PM, seno wrote:
> I tried that patch on compat-wireless-2010-10-25 (Kernel 2.6.33.7).
> 
> Performance improves minimal, but thousands of errors occur in iwconfig output.
> (Tx excessive retries, Invalid misc, Missed beacon).
> 
> The router also shows lots of errors 
> (for Received (RX) / Transmitted (TX) packets)

I no longer remember the details of why this patch was abandoned, but I suspect
you found the answer.

Larry
