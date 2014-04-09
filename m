Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:51010 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932685AbaDINXG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 09:23:06 -0400
Message-ID: <1397049772.4418.71.camel@dubbel> (sfid-20140409_152311_981025_7BAD80FD)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Wed, 09 Apr 2014 16:22:52 +0300
In-Reply-To: <1397049062-24177-2-git-send-email-michal.kazior@tieto.com>
References: <1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
	 <1397049062-24177-1-git-send-email-michal.kazior@tieto.com>
	 <1397049062-24177-2-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v4 1/4] mac80211: fix CSA tx queue locking
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 15:10 +0200, Michal Kazior wrote:
> v4:
>  * improve commit message (locked vs stopped) [Luca]

Maybe the subject should be changed too? But I think either Johannes or
I (whoever apply the series) can easily fix it up while applying...

--
Luca.

