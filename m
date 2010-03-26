Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47653 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab0CZGPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 02:15:19 -0400
Received: by bwz1 with SMTP id 1so1524585bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 23:15:17 -0700 (PDT)
To: Zhu Yi <yi.zhu@intel.com>
Cc: "linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] mac80211: support paged rx SKBs
References: <1269399463-5244-1-git-send-email-yi.zhu@intel.com>
	<87eij8c3ld.fsf@purkki.valot.fi> <1269575877.4043.203.camel@debian>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 26 Mar 2010 08:15:14 +0200
In-Reply-To: <1269575877.4043.203.camel@debian> (Zhu Yi's message of "Fri\, 26 Mar 2010 11\:57\:57 +0800")
Message-ID: <87k4sz38y5.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi <yi.zhu@intel.com> writes:

>> I think ieee80211_rx{_irqsafe} documentation should now mention that
>> paged skbs are supported. Better to make this suppot explicit for the
>> driver authors.
>
> Good idea it should be documented somewhere (after the patch is
> accepted). Maybe the developer wiki page?

I was thinking to add it to include/net/mac80211.h. Better to have all
documentation in one place.

> For the code itself, I think Linux drivers can always assume the
> network stacks support paged buffers.

But this wasn't true with mac80211 before your patch, right? So now
it's better to state this clearly in mac80211 documentation.

-- 
Kalle Valo
