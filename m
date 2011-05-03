Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51122 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab1ECMu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 08:50:27 -0400
Received: by yia27 with SMTP id 27so11729yia.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 05:50:26 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 3 May 2011 16:50:26 +0400
Message-ID: <BANLkTiniamP_zXeGkW2TgatdkSv1+rdfeg@mail.gmail.com> (sfid-20110503_145030_136239_6389868C)
Subject: carl9170.ko RX - DMA, TX - COPY.
From: "Andrew V. Stepanov" <stanv@altlinux.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

I'm very surprising, that carl9170.ko uses DMA only for receiving.

Is it possible to use DMA for sending packets in carl9170?

Can anybody shed some light on this?

Thanks!
