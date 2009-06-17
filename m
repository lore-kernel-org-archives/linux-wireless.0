Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:51220 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbZFQRXg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 13:23:36 -0400
Received: by gxk10 with SMTP id 10so739508gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2009 10:23:38 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 17 Jun 2009 10:23:18 -0700
Message-ID: <43e72e890906171023y4668be30pbf98a668e9ec7bc7@mail.gmail.com>
Subject: FYI - 2.6.27 should work with PS buffering now
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, Felix Fietkau <nbd@openwrt.org>,
	Imre Kaloz <kaloz@openwrt.org>,
	Gabor Juhos <juhosg@openwrt.org>, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the skb->requeue stuff is gone PS buffering should work now
through the backport work on compat-wireless down to 2.6.27 again. I
haven't tested but it should. Other nice thing I should not is once
master dev is removed we should be able to add backport support down
to 2.6.22 again.

  Luis
