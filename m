Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:4293 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbZDZP7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2009 11:59:45 -0400
Received: by fk-out-0910.google.com with SMTP id 18so913526fkq.5
        for <linux-wireless@vger.kernel.org>; Sun, 26 Apr 2009 08:59:43 -0700 (PDT)
Subject: PHY hangs on AR2425 (AR5007EG)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: ath5k-devel <ath5k-devel@lists.ath5k.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 26 Apr 2009 18:59:39 +0300
Message-Id: <1240761579.10972.11.camel@maxim-laptop> (sfid-20090426_175950_488290_63BE0922)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I updated today the kernel, on aspire one to the latest
wireless-testing.

Still it has the same issue it had, and I want to ask you if you have
any ideas about it. 


The issue is that if I load its TX unit up to it's maximum throughput,
it stalls each and every few seconds, and only way to make it work
again, is to reset it (doing iwlist scan for example, or wait till
driver resets it).

I could reproduce the above even with lighter loads, but less often.

In winxp, I get 2.7 download / 2.3 upload speeds, and the speed is
constant.

(it survived 15 minutes of testing in both directions at above speeds)

What do you think,

Best regards,
	Maxim Levitsky

