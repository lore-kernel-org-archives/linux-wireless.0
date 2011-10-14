Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:49566 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab1JNPqy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 11:46:54 -0400
Received: by wwn22 with SMTP id 22so958651wwn.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2011 08:46:53 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 14 Oct 2011 19:46:53 +0400
Message-ID: <CAN=pzd+TcY+n90RBMU+Cpp0Bt9d_eAGgY4yffO+PSStWSzbf-Q@mail.gmail.com> (sfid-20111014_174657_577460_36D825D3)
Subject: Ath9k, single antenna on ar9280
From: Stanislav Demakov <s.demakov@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've noticed that set_antenna and get_antenna functionality was added
to the ath9k driver. But iw phy set antenna command still isn't
working.

I know that before there was a workaround by setting chainmasks number
to 1, but this is not exactly what I need. I just need to enable only
one physical antenna and allow the adapter work only in 1x1 mode.
Is it possible?
