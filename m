Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57628 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759729Ab1CDTHC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 14:07:02 -0500
Received: by vxi39 with SMTP id 39so2286085vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2011 11:07:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299238635.4348.6.camel@jlt3.sipsolutions.net>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
 <1299208307-9428-7-git-send-email-thomas@cozybit.com> <1299238635.4348.6.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 4 Mar 2011 11:06:41 -0800
Message-ID: <AANLkTim-cdTV6dsZg9MmMFMejkN8SpNYr=RBY-s8kiF=@mail.gmail.com>
Subject: Re: [PATCH 6/7] mac80211: Parse RSN information element to determine
 if a peer needs authentication
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 4, 2011 at 3:37 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-03-03 at 19:11 -0800, Thomas Pedersen wrote:
>> From: Javier Cardona <javier@cozybit.com>
>
> [...]
>
> If you manage stations in userspace, then this code is unnecessary.
> That'd be a big win in my eyes. The only thing the kernel would need to
> know is not to create station entries, right?

If userspace manages only rsn mesh stations then we do still need
this.  That would be my preference:  only require an authentication
daemon if you intend to join a secure mesh.  In the same way that you
can connect to an open AP without a daemon.
Would you object to this approach?


-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
