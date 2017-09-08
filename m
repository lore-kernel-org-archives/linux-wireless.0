Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37140 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755752AbdIHOql (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 10:46:41 -0400
Message-ID: <1504881999.20347.6.camel@sipsolutions.net> (sfid-20170908_164712_139783_CC15F89B)
Subject: Re: [RFC 4/4] mac80211_hwsim: add radio idx param to netlink
 callback of radio creation
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 08 Sep 2017 16:46:39 +0200
In-Reply-To: <5635378a-1d80-99f6-0538-9a9c9a7bc0fe@uni-rostock.de>
References: <20170908141137.3941-1-benjamin.beichler@uni-rostock.de>
         <c6eda3a2-ad9b-4c33-b3c8-ddc36199ea3e@MAIL1.uni-rostock.de>
         <1504880886.20347.4.camel@sipsolutions.net>
         <5635378a-1d80-99f6-0538-9a9c9a7bc0fe@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Uh. Is there anything you can do not to mangle your replies? I don't
even know what you're replying to etc.

> AFAIK, you can change the MAC-Address of an interface on
> the phy, but not the perm address of the phy. But for frames sent to
> a wmediumd always the perm address is used to identify the sender and
> receiver. It is really annoying to additionally keep a translation
> table in userspace to manage between random ids/mac-addresses to them
> you use in a simulation for this.

I think we tried to fix that once, but that caused more problems ...

I'd rather allow you to then specify the MAC address though - the
index/address mapping doesn't need to be the identity, after all.

johannes
