Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55112 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab1JDMZI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 08:25:08 -0400
Received: by ywb5 with SMTP id 5so400870ywb.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 05:25:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E8AE1CC.5060703@openwrt.org>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
	<1317637758-11907-5-git-send-email-zefir.kurtisi@neratec.com>
	<CAB=NE6XxW_kMnWLkC4dy4naUKaTk_hZi0_F86LNyuk3RNyqNQA@mail.gmail.com>
	<4E8AD800.9040208@neratec.com>
	<4E8AE1CC.5060703@openwrt.org>
Date: Tue, 4 Oct 2011 20:25:07 +0800
Message-ID: <CAJ-Vmom_3p3f_wV+60Crhy29Bn0ZkfVb=6b+ME5qSM_7u5NPaQ@mail.gmail.com> (sfid-20111004_142512_820368_554E5767)
Subject: Re: [RFC 4/6] ath9k: add DFS build parameter
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. ditto for FreeBSD.

I'm hoping we can both leverage the same shared radar classification
modules with little changes needed in code. I'd like this to work for
at least AR9280.


Adrian
