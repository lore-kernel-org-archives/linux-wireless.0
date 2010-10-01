Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39704 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab0JARyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 13:54:06 -0400
Received: by gwj17 with SMTP id 17so1233360gwj.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 10:54:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi==09DXcF-Cbon7SFUxU8WbUMx6ZL8OQP5g8=5z@mail.gmail.com>
References: <733457.84719.qm@web56801.mail.re3.yahoo.com> <AANLkTi==09DXcF-Cbon7SFUxU8WbUMx6ZL8OQP5g8=5z@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 1 Oct 2010 10:53:44 -0700
Message-ID: <AANLkTi=JsFKYRnErHfP_eAYbrmjsG05E3NHHsmtGr+bK@mail.gmail.com>
Subject: Re: [BUG] compat: broken driver-select always compiles ath6kl & brcm80211
To: Michael Griepentrog <griepent@cs.wisc.edu>
Cc: Walter Goldens <goldenstranger@yahoo.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 30, 2010 at 8:33 AM, Michael Griepentrog
<griepent@cs.wisc.edu> wrote:
> driver-select currently doesn't modify the Makefiles of drivers in
> staging, so they will always be built.

I've now disabled staging crap for every driver-select option except
ones that want staging crap.

  Luis
