Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f193.google.com ([209.85.221.193]:37988 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbZFXUYb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 16:24:31 -0400
Received: by qyk31 with SMTP id 31so1382808qyk.33
        for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2009 13:24:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090624120745.239294066@sipsolutions.net>
References: <20090624120745.239294066@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 24 Jun 2009 13:24:14 -0700
Message-ID: <43e72e890906241324n341f4988wc6e7325ee389e71e@mail.gmail.com>
Subject: Re: [RFC 00/11] cfg80211 connect API + wireless extension move
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 24, 2009 at 5:07 AM, Johannes Berg<johannes@sipsolutions.net> wrote:

>  Maybe we even decide to
> not internalise it this way because orinoco wants to keep
> some ioctls that we'll not offer in cfg80211, not sure yet.

Hm, which ones?

  Luis
