Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f46.google.com ([209.85.128.46]:47765 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab3CFXgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 18:36:54 -0500
Received: by mail-qe0-f46.google.com with SMTP id a11so5690239qen.5
        for <linux-wireless@vger.kernel.org>; Wed, 06 Mar 2013 15:36:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1362571344.8457.9.camel@jlt4.sipsolutions.net>
References: <CA++BO6QA9cFmM2kU4u8ASxWqJeGwUB1385awKfXLP=O0fA87NA@mail.gmail.com>
	<1362571344.8457.9.camel@jlt4.sipsolutions.net>
Date: Wed, 6 Mar 2013 18:36:53 -0500
Message-ID: <CA++BO6TciosdjiFaSAPvyCYsTU-J8UKCefPtxc8bcc04fnh9mQ@mail.gmail.com> (sfid-20130307_003708_463382_6CDB4404)
Subject: Re: mac80211: regression: fd0f979 no long authenticates w/ath9k_htc
From: Corey Richardson <corey@octayn.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 6, 2013 at 7:02 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Do you think you could run trace-cmd to capture what's going on before
> and after?
>

What should I be recording? The NetworkManager process? I'm unfamiliar
with ftrace.
