Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:40581 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266AbZHYRC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 13:02:59 -0400
Received: by ewy2 with SMTP id 2so637585ewy.17
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 10:02:59 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 25 Aug 2009 19:02:58 +0200
Message-ID: <da0cccbf0908251002l572ea238x5cf1685be06edcbd@mail.gmail.com>
Subject: B44 not being installed
From: Gregy <p.gregy@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, I would like to report something that looks like a bug to me.
compat-wireless 2009-08-25
kernel 2.6.31-rc4
With stock config.mk b44 is enabled and should be compiled and
installed with make && make install
I fact it is not compiled and installed -> after I load new ssb wired
network stops working

Could you please look into it?

Thanks
