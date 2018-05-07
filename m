Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53646 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752200AbeEGMhy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 08:37:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 09/18] net: mac80211.h: fix a bad comment line
References: <cover.1525684985.git.mchehab+samsung@kernel.org>
        <cover.1525684985.git.mchehab+samsung@kernel.org>
        <1b14ef4f63547c86c544e112b74acfff2b41f4af.1525684985.git.mchehab+samsung@kernel.org>
Date: Mon, 07 May 2018 15:37:48 +0300
In-Reply-To: <1b14ef4f63547c86c544e112b74acfff2b41f4af.1525684985.git.mchehab+samsung@kernel.org>
        (Mauro Carvalho Chehab's message of "Mon, 7 May 2018 06:35:45 -0300")
Message-ID: <87fu334p5v.fsf@purkki.adurom.net> (sfid-20180507_143812_018740_BDE8837E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mauro Carvalho Chehab <mchehab+samsung@kernel.org> writes:

> Sphinx produces a lot of errors like this:
> 	./include/net/mac80211.h:2083: warning: bad line:  >
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Randy already submitted a similar patch:

https://patchwork.kernel.org/patch/10367275/

But it seems Johannes has not applied that yet.

-- 
Kalle Valo
