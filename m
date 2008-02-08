Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.232]:61547 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbYBHR0P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2008 12:26:15 -0500
Received: by wr-out-0506.google.com with SMTP id c48so3654930wra.23
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2008 09:26:12 -0800 (PST)
Message-ID: <1ba2fa240802080926s69ff64d8gf169b089f2e642f7@mail.gmail.com> (sfid-20080208_172620_336561_52B97E8C)
Date: Fri, 8 Feb 2008 19:26:10 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi aggregation support and queues?
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1202477245.5718.43.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1202477245.5718.43.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 8, 2008 3:27 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hi,
>
> I just found that iwlwifi has its own queue allocation scheme
> (iwl4965_txq_ctx_activate_free) when mac80211 already takes care of
> that. Why, and why did you add code for that to mac80211 at all then?
>
 These are for hw queues book keeping. There is no ex exactly 1:1
mapping between HW and SW queues.
Tomas

> johannes
>
