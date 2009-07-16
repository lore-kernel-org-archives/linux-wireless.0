Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:44679 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbZGPJMW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:12:22 -0400
Received: by bwz28 with SMTP id 28so1920142bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 02:12:21 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless: remove print_mac uses
References: <1247671301.10754.6.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Jul 2009 12:12:19 +0300
In-Reply-To: <1247671301.10754.6.camel@johannes.local> (Johannes Berg's message of "Wed\, 15 Jul 2009 17\:21\:41 +0200")
Message-ID: <87ab3556vg.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Use %pM instead, and also remove stray variables
> declared with DECLARE_MAC_BUF.

Thanks, I'm glad that we can ditch that ugly print_mac().

For the wl1251 part:

Acked-by: Kalle Valo <kalle.valo@nokia.com>

-- 
Kalle Valo
