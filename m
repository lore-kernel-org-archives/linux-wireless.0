Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:37384 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753AbcFBOEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 10:04:15 -0400
Received: by mail-wm0-f47.google.com with SMTP id z87so71135479wmh.0
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2016 07:04:14 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 2 Jun 2016 16:04:13 +0200
Message-ID: <CAAfyv37Sr7JRtfrZYyb=c530sK8PR_ymeJ6w38274i1aDkHZ8A@mail.gmail.com> (sfid-20160602_160423_894028_393CD542)
Subject: iw reg overwritten after connecting to AP
From: Belisko Marek <marek.belisko@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm using kernel 4.1 with option CONFIG_CFG80211_INTERNAL_REGDB
enabled. I have set one country in db.txt which during startup I set
via 'iw reg set XX'. When connected to some AP which sends country
code (e.g. SK) region is overwritten to 00 (in kernel log there is
some timeout message - I suppose it's communication with crda daemon
which I'm not using). Is there a way how to override this behavior (to
keep my regulatory persistent). Many thanks.

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
