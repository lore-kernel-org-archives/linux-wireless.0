Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:34162 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbcCVJhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 05:37:36 -0400
Received: by mail-qg0-f42.google.com with SMTP id w104so173543202qge.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2016 02:37:36 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 22 Mar 2016 03:37:35 -0600
Message-ID: <CAAA5faG+AOviPrJxd9dOuZrDAkm+4F5sy0M7w3MW0U-ufNeZ3g@mail.gmail.com> (sfid-20160322_103740_333691_AE72076E)
Subject: making fq_codel default
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Everyone,

Everytime I boot I need to set fq_codel for my wireless interface:

sudo tc qdisc add   dev wlp4s0 root fq_codel

I also need to sudo sysctl -w net.core.default_qdisc=fq_codel

Is there a good way to have this as the default in the kernel config
instead of pfifo?
Also, are there plans for cake support or do fq_codel in this case mean cake?
Thanks,

Reinoud.
