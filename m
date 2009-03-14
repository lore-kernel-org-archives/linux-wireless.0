Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:18506 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbZCNXkb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 19:40:31 -0400
Received: by rv-out-0506.google.com with SMTP id g37so979990rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 14 Mar 2009 16:40:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237020169.5235.66.camel@johannes.local>
References: <1237020169.5235.66.camel@johannes.local>
Date: Sat, 14 Mar 2009 19:40:29 -0400
Message-ID: <b6c5339f0903141640j6f0ef1e0rccb4034006c9ba1f@mail.gmail.com> (sfid-20090315_004034_680565_414FF2C8)
Subject: Re: [PATCH] mac80211: acquire sta_lock for station suspend/resume
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 14, 2009 at 4:42 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> To avoid concurrent manipulations of the sta list (which shouldn't
> be possible at this point, but anyway) we need to hold the sta_lock
> around iterating the list.
>
> At the same time, we do not need to iterate the list at all if
> the driver doesn't want to be notified.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com
