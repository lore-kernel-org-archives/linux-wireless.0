Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45140 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbaGUKB6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 06:01:58 -0400
Message-ID: <1405936900.32255.7.camel@jlt4.sipsolutions.net> (sfid-20140721_120211_946386_736C47E3)
Subject: Re: [PATCH v11 0/5] cfg/mac80211: implement multi-vif csa
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Mon, 21 Jul 2014 12:01:40 +0200
In-Reply-To: <CA+BoTQmizEd3joLf6XDuUrq1Ton_XWcTwKCzWHJcD=gbzVGoMg@mail.gmail.com> (sfid-20140630_114605_200258_A9D95372)
References: <1403692510-27873-1-git-send-email-michal.kazior@tieto.com>
	 <1403722063.4140.19.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmizEd3joLf6XDuUrq1Ton_XWcTwKCzWHJcD=gbzVGoMg@mail.gmail.com>
	 (sfid-20140630_114605_200258_A9D95372)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-06-30 at 11:46 +0200, Michal Kazior wrote:

> Btw. What is the plan regarding re-enabling CSA itself?

I guess we should?

johannes

