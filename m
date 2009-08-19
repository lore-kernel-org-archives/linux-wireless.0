Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:33534 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZHSSTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 14:19:44 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1538980qwh.37
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 11:19:45 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 19 Aug 2009 11:19:44 -0700
Message-ID: <8f3763990908191119l37c7dff3y8884b1228059cb22@mail.gmail.com>
Subject: bug? sme.c:610 __cfg80211_disconnected
From: ASIC Felix <ic.felix@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

update:
   occurs during rekeying/reauth on wpa2 office network
   still present in master-2009-08-19

Aug 19 11:04:02 darkslate klogd: WARNING: at net/wireless/sme.c:613
__cfg80211_disconnected+0x1bc/0x210 [cfg80211]()

Cheers,
Felix
