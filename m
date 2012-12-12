Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:35142 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab2LLKtF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 05:49:05 -0500
Received: by mail-wg0-f46.google.com with SMTP id dr13so211441wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2012 02:49:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355309167.9708.0.camel@jlt4.sipsolutions.net>
References: <1355308099-18193-1-git-send-email-machen@suse.com>
	<1355309167.9708.0.camel@jlt4.sipsolutions.net>
Date: Wed, 12 Dec 2012 02:49:03 -0800
Message-ID: <CAJ-VmokUOyOMrh_d14O__J1VL2woDiCsbk96KeA3stqsLhz20g@mail.gmail.com> (sfid-20121212_114913_577175_9F9F6850)
Subject: Re: [PATCH] mac80211: modify max_nullfunc parameter
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Chen, Chien-Chia" <machen@suse.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, first question is figuring out why that's occuring. It's not
being sent at some really ridiculously high rate, is it?


Adrian
