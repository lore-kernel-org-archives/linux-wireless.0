Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37350 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaFNA1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 20:27:37 -0400
Received: by mail-pd0-f180.google.com with SMTP id ft15so2594461pdb.39
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2014 17:27:37 -0700 (PDT)
Message-ID: <539B96F7.9090101@gmail.com> (sfid-20140614_022741_805802_46D8254A)
Date: Fri, 13 Jun 2014 17:27:35 -0700
From: Gus Wirth <gwirth79@gmail.com>
MIME-Version: 1.0
To: Mathy Vanhoef <vanhoefm@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>
CC: ath5k-devel@lists.ath5k.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 2/2] ath5k: capture CCK and OFDM restarts
References: <539B7019.1050801@gmail.com> <539B7639.30104@openwrt.org> <539B85F0.3090004@gmail.com>
In-Reply-To: <539B85F0.3090004@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-06-13 16:14, Mathy Vanhoef wrote:
[snip]
> Just saw a spelling mistake in the comment, s/Threat/Treat.

One more mistake in the comment.

Change the word "of" to "or":


...underwent a CCK of OFDM reset...

should be

...underwent a CCK or OFDM reset...

Gus
