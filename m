Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55074 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750929AbdJGOxT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Oct 2017 10:53:19 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Madhu K <madhu.sk89@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Linux wireless device driver tutorials.
References: <CAA2oCOkCdKeyioo=26BMj1spvxjHQ+vM4S+ZUSgxbF8qisAY=A@mail.gmail.com>
Date: Sat, 07 Oct 2017 17:53:15 +0300
In-Reply-To: <CAA2oCOkCdKeyioo=26BMj1spvxjHQ+vM4S+ZUSgxbF8qisAY=A@mail.gmail.com>
        (Madhu K.'s message of "Sat, 7 Oct 2017 11:33:47 +0530")
Message-ID: <878tgnxb50.fsf@purkki.adurom.net> (sfid-20171007_165322_905285_EB4A63FB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Madhu K <madhu.sk89@gmail.com> writes:

> I am kernel newbie, I am trying to understand the linux wireless
> architecture and wanted write some simple drivers. Please somebody
> help me to get the documents related this?

This is not about wireless but still I think a must read for anyone new
with kernel development:

https://lwn.net/Kernel/LDD3/

For wireless development take a look at simple drivers like wl1251 or
mac80211_hwsim and start studying how they work.

And of course you need to check the wiki:

https://wireless.wiki.kernel.org/

-- 
Kalle Valo
