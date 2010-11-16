Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56891 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab0KPUM6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 15:12:58 -0500
Received: by iwn35 with SMTP id 35so1187235iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 12:12:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikb+2PypN+nOGDYbuN1mRGjWCZRuTQ16HsRNo=p@mail.gmail.com>
References: <AANLkTikb+2PypN+nOGDYbuN1mRGjWCZRuTQ16HsRNo=p@mail.gmail.com>
Date: Tue, 16 Nov 2010 21:12:57 +0100
Message-ID: <AANLkTi=PZ8TH2PG7rKz9-nt3S4ZLzvMw_478QrYOpVkm@mail.gmail.com>
Subject: [iwlwifi] Rate Adaptation
From: "An (Jack) Chan" <jackachan@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I am a beginner on developing wireless drivers. I am looking into
iwl5000 driver as we have some Intel 5300 cards here.

Does anyone know where I can find the implementation of rate
adaptation in iwl5000 driver? Or it is implemented in firmware?
I do find rate tables and a iwl_set_rate function in iwl-core.c, but
it seems not the rate adaptation implementation.

Thank you,

Jack
