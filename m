Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60342 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758256Ab3GMUiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jul 2013 16:38:10 -0400
Message-ID: <1373747861.5549.0.camel@jlt4.sipsolutions.net> (sfid-20130713_223827_323007_94DBCBC3)
Subject: Re: [PATCH] mac80211: fix duplicate retransmission detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 13 Jul 2013 23:37:41 +0300
In-Reply-To: <CAKf6xpu7iUSKWsFwsUnV2Nv2XjWepzaXv6s=3WvcgB6dY20oGQ@mail.gmail.com> (sfid-20130713_182804_436862_6B7253C5)
References: <1373575017-25645-1-git-send-email-johannes@sipsolutions.net>
	 <CAKf6xpu7iUSKWsFwsUnV2Nv2XjWepzaXv6s=3WvcgB6dY20oGQ@mail.gmail.com>
	 (sfid-20130713_182804_436862_6B7253C5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-07-13 at 12:28 -0400, Jason Andryuk wrote:

> > +       if (rx->skb->len >= 24 && rx->sta &&
> 
> Shouldn't this check rx->skb first?
> if (rx->sta && rx->sta->len >= 24 &&

Hmm? did you mean rx->skb? But what makes you think it can be NULL???

johannes

