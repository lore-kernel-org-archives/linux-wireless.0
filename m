Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:64034 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbZD2UYd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 16:24:33 -0400
Received: by bwz7 with SMTP id 7so1410852bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2009 13:24:32 -0700 (PDT)
Subject: Re: PHY hangs on AR2425 (AR5007EG)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: ath5k-devel <ath5k-devel@lists.ath5k.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1240761579.10972.11.camel@maxim-laptop>
References: <1240761579.10972.11.camel@maxim-laptop>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 23:24:27 +0300
Message-Id: <1241036667.12942.0.camel@maxim-laptop> (sfid-20090429_222438_091763_14CD269B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-04-26 at 18:59 +0300, Maxim Levitsky wrote:
> I updated today the kernel, on aspire one to the latest
> wireless-testing.
> 
> Still it has the same issue it had, and I want to ask you if you have
> any ideas about it. 
> 
> 
> The issue is that if I load its TX unit up to it's maximum throughput,
> it stalls each and every few seconds, and only way to make it work
> again, is to reset it (doing iwlist scan for example, or wait till
> driver resets it).
> 
> I could reproduce the above even with lighter loads, but less often.
> 
> In winxp, I get 2.7 download / 2.3 upload speeds, and the speed is
> constant.
> 
> (it survived 15 minutes of testing in both directions at above speeds)
> 
> What do you think,
> 
> Best regards,
> 	Maxim Levitsky
> 

Are you aware of that bug?



