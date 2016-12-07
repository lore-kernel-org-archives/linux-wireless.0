Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33908 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751610AbcLGHiN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 02:38:13 -0500
Message-ID: <1481096290.4092.23.camel@sipsolutions.net> (sfid-20161207_083815_678997_F29087B3)
Subject: Re: [PATCH][RFC] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 07 Dec 2016 08:38:10 +0100
In-Reply-To: <5847B51A.6090303@gmail.com> (sfid-20161207_080708_346764_81655F78)
References: <20161202205611.14141-1-andrew.zaborowski@intel.com>
         <1480945883.31788.3.camel@sipsolutions.net> <58457FEA.4030305@gmail.com>
         <1480949899.31788.34.camel@sipsolutions.net> <5845824B.4090304@gmail.com>
         <1480950886.31788.44.camel@sipsolutions.net> <584588A2.9090006@gmail.com>
         <1481008560.6610.3.camel@sipsolutions.net> <584730D7.2020708@gmail.com>
         <1481091301.4092.5.camel@sipsolutions.net> <5847AEF9.90409@gmail.com>
         <1481093287.4092.20.camel@sipsolutions.net> <5847B51A.6090303@gmail.com>
         (sfid-20161207_080708_346764_81655F78)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > > Fair enough.  I think we can live with that since we're not using
> > > CMD_AUTHENTICATE unless we need to roam using FT.
> > 
> > That seems like a very strange decision, but it's obviously up to
> > you
> > :)
> > 
> 
> Care to elaborate ?

Well, for example, you won't be able to do SAE, the upcoming FILS or
generally have any control over what's going on in the auth/assoc
handshake, since the kernel's version thereof is really really simple.

johannes
