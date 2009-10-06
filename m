Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:47188 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316AbZJFPip (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 11:38:45 -0400
Received: by iwn8 with SMTP id 8so2305285iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2009 08:38:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ACB4BA3.9090406@gmail.com>
References: <4ACB4BA3.9090406@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 6 Oct 2009 11:37:49 -0400
Message-ID: <43e72e890910060837o576bc598qca4a9b4b25d81d64@mail.gmail.com>
Subject: Re: [PATCH] mac80211: use kfree_skb() to free struct sk_buff pointers
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 6, 2009 at 9:52 AM, Roel Kluin <roel.kluin@gmail.com> wrote:
> kfree_skb() should be used to free struct sk_buff pointers.

cc'ing stable would be good for this one it seems.

  Luis
