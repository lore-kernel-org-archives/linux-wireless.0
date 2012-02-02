Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65487 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab2BBP1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 10:27:37 -0500
Received: by iacb35 with SMTP id b35so3270115iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 07:27:37 -0800 (PST)
Message-ID: <4F2AAB65.6000409@lwfinger.net> (sfid-20120202_162740_880899_53F4AD48)
Date: Thu, 02 Feb 2012 09:27:33 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jenny <coamicoami@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8188SU
References: <CA+ff7uV5SmsOrP3Zi-nf70rfSTse5g47ziFEAqPFyuB5RD6K8A@mail.gmail.com>
In-Reply-To: <CA+ff7uV5SmsOrP3Zi-nf70rfSTse5g47ziFEAqPFyuB5RD6K8A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/02/2012 01:27 AM, Jenny wrote:
> Hello!
> I have an adapter that has rtl8188su and I wanted to know if by any chance you
> had or knew of a patch that would make monitor mode work with it. I've heard
> that with rtl8188cu and rtl8188ru, firmware from rtl8792cu worked well. I tried
> it, even tough I was able to get online I wasn't able to to get monitor mode.
> I also tried compat wireless and that didn't have any effect.

If I remember correctly, the RTL8188SU uses r8712u as the driver. That driver 
does not work in monitor mode (as an AP). I have been trying to find the 
problem, but the time that I have available is limited.

Sorry,

Larry

