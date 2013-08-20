Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f193.google.com ([209.85.214.193]:42164 "EHLO
	mail-ob0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab3HTGjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 02:39:05 -0400
Received: by mail-ob0-f193.google.com with SMTP id dn14so9314obc.8
        for <linux-wireless@vger.kernel.org>; Mon, 19 Aug 2013 23:39:04 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 20 Aug 2013 12:09:04 +0530
Message-ID: <CAC+8=6HoRZFo1rZ8DOEkuYV0gFxPEV4C7dOWSDWNV4CgSBtB7g@mail.gmail.com> (sfid-20130820_083909_600099_AC64B898)
Subject: wifi hw emulator
From: Mahesh Palivela <mpwlan@gmail.com>
To: linux <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we are trying to test mac80211 stack dependant driver to tx/rx dot11
pkts on another interface driver like Ethernet. Is there a way to pass
pkts/skbs driver to driver?

Basically we don't have the real hw yet, so want to use another physical medium.

Thanks in advance for your help.

Best regards,
Mahesh
