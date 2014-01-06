Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:33758 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaAFJSb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 04:18:31 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so18246316pbb.14
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jan 2014 01:18:27 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 6 Jan 2014 11:18:27 +0200
Message-ID: <CAP+W=6QCwL1hbz5fRKuBr7dCS58_fVFTQ-mFjgW5rTr6y6QO-w@mail.gmail.com> (sfid-20140106_101835_494224_E4B3F992)
Subject: r92su driver for realtek rtl8192su usb wireless adapte
From: Julian Gordon <jewelsofthought@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have downloaded the dirver from http://github.com/chunkeey/rtl8192su for
the adapter.

Upon running the make, it reports an error: it cannot find
IEEE80211_NUM_TIDS in file r92/su/sta.h:120:26.

Where can I find the correct defintion for this varaible or an alternative
to it?

I am running on ubuntu 12.04 64b, with kernel 3.2.0-58-generic.

Regards,--

-- 
Julian Gordon,
South Africa: +27 (021) 650-3210
Cell: +27 (083) 226-5482
Email
--

Not everything that is faced can be changed. But nothing can be
changed until it is faced.
