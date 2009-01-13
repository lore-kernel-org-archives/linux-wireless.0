Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:26847 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZAMA5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 19:57:32 -0500
Received: by ey-out-2122.google.com with SMTP id 22so1391703eye.37
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2009 16:57:30 -0800 (PST)
Message-ID: <2d0a357f0901121657s1ea091b6m824e8f939be2d51d@mail.gmail.com> (sfid-20090113_015734_958163_3575D658)
Date: Tue, 13 Jan 2009 01:57:30 +0100
From: "Sedat Dilek" <sedat.dilek@googlemail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [master-2009-01-12] compiler-error in 'drivers/net/irda/donauboe.c'
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I could not compile latest wl.git due to problems in
'drivers/net/irda/donauboe.c'.
A fix and description is given in [1].
Hope this helps other people.

Regards,
Sedat

[1] http://patchwork.kernel.org/patch/1791/
