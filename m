Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45160 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab1JDOe7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 10:34:59 -0400
Received: by yxl31 with SMTP id 31so536848yxl.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 07:34:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E8B157F.2080203@neratec.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
	<201110032124.53937.chunkeey@googlemail.com>
	<CAB=NE6XBkisvFmj6F7wS6i8XV7WEsM6bQ5zsXFWXm9XM8z0pwA@mail.gmail.com>
	<201110041538.12885.chunkeey@googlemail.com>
	<4E8B157F.2080203@neratec.com>
Date: Tue, 4 Oct 2011 22:34:58 +0800
Message-ID: <CAJ-Vmo=TACq_d7JU0stibcqnvWgzUO7Ozue=4VayeHNcgXTejw@mail.gmail.com> (sfid-20111004_163502_320782_7135A45D)
Subject: Re: [RFC 5/6] ath9k: enable DFS pulse detection
From: Adrian Chadd <adrian@freebsd.org>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.. erm, how complicated is the pattern matching code when it's compiled?

The port of the fusion radar detection module didn't end up being all that big.



Adrian
