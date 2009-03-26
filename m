Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:51274 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782AbZCZOlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 10:41:55 -0400
Received: by qyk16 with SMTP id 16so1019429qyk.33
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 07:41:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238066858.4331.30.camel@johannes.local>
References: <1238066858.4331.30.camel@johannes.local>
Date: Thu, 26 Mar 2009 10:41:52 -0400
Message-ID: <b6c5339f0903260741i33264d5dy5e48a5c182cce387@mail.gmail.com> (sfid-20090326_154158_644787_4D582F34)
Subject: Re: [PATCH] mac80211: add driver ops debugging
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 26, 2009 at 7:27 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> This patch adds (optional) debugging for each driver call
> (except tx) that can print out the call, its parameters and
> the return value from the driver.

Could we use some newfangled thing like tracepoints for this
instead of printk?  Disclaimer: I know nothing about such
things.

-- 
Bob Copeland %% www.bobcopeland.com
