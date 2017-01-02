Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39930 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932557AbdABOKN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 09:10:13 -0500
Message-ID: <1483366209.21014.7.camel@sipsolutions.net> (sfid-20170102_151014_960567_55B5CC88)
Subject: Re: [PATCH V2 1/3] cfg80211: allow passing struct device in the
 wiphy_new call
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Mon, 02 Jan 2017 15:10:09 +0100
In-Reply-To: <CACna6rzc2hk2xosd54eZVSUCtqgtT5E2vii24rgWBV96PR1W7A@mail.gmail.com> (sfid-20170102_150530_098112_601BD14A)
References: <20170102132747.3491-1-zajec5@gmail.com>
         <1483364298.21014.3.camel@sipsolutions.net>
         <CACna6rzc2hk2xosd54eZVSUCtqgtT5E2vii24rgWBV96PR1W7A@mail.gmail.com>
         (sfid-20170102_150530_098112_601BD14A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 2) mac80211 - it's a big one as it's used in SET_IEEE80211_DEV
> 
> I was planning to work on mac80211 drivers later. This will require
> similar modification of ieee80211_alloc_hw.

Ah, ok, thanks for the explanation.

johannes
