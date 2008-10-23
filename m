Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:15878 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYJWQy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 12:54:58 -0400
Received: by ti-out-0910.google.com with SMTP id b6so237176tic.23
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 09:54:57 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18688.43984.384332.787060@localhost.localdomain> (sfid-20081023_185504_127328_74E7B7CA)
Date: Thu, 23 Oct 2008 22:22:32 +0530
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, Luis.Rodriguez@atheros.com,
	Jouni.Malinen@atheros.com, johannes@sipsolutions.net,
	tomasw@gmail.com
Subject: Re: [PATCH v3] mac80211: Re-enable aggregation
In-Reply-To: <20081023145102.GA5816@tuxdriver.com>
References: <18685.37489.577735.596008@gargle.gargle.HOWL>
	<43e72e890810222010w215b278bya788e0c94250b517@mail.gmail.com>
	<20081023145102.GA5816@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> > Poke.
> 
> Just waiting to see comments from those who understand aggregation
> better than I do...

It doesn't change the existing behaviour in any way, ath9k doesn't need
all the extra queue stuff, so this is only a temporary fix until
we have a decent model in mac80211 to support HW with no ampdu_queues.

But that patch probably won't apply now, I'll rebase it and send again.

Sujith
