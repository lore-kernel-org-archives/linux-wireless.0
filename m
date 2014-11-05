Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40497 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaKEDXq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 22:23:46 -0500
Received: by mail-lb0-f174.google.com with SMTP id p9so1320268lbv.5
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2014 19:23:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1414046257-22184-6-git-send-email-arik@wizery.com>
References: <1414046257-22184-1-git-send-email-arik@wizery.com> <1414046257-22184-6-git-send-email-arik@wizery.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 4 Nov 2014 19:23:23 -0800
Message-ID: <CAB=NE6WLnVcBtC5_HyVuDXJnrCUfhUKsPN_rAHL6VYEfek1TMA@mail.gmail.com> (sfid-20141105_042349_891422_97D6D57E)
Subject: Re: [PATCH 5/5] cfg80211: Allow usermode to query wiphy specific regd info
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jonathan Doron <jond@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2014 at 11:37 PM, Arik Nemtsov <arik@wizery.com> wrote:
> + * @NL80211_ATTR_WIPHY_SELF_MANAGED_REG: flag attribute indicating the
> + *     regulatory information came from the driver and not from the global
> + *     cfg80211 regulatory domain information.

Awesome, can you also add another entry for those drivers that use
regulatory_hint() API given that the wiphy->regd will be set and then
that is a custom regdomain which I do think would be great to query as
well.

 Luis
