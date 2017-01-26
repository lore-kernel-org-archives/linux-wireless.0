Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47728 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752852AbdAZIva (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 03:51:30 -0500
Message-ID: <1485420684.11038.2.camel@sipsolutions.net> (sfid-20170126_095152_179718_74BAA6F5)
Subject: Re: [PATCH 1/2] mac80211: use helper function to access
 ieee802_1d_to_ac[]
From: Johannes Berg <johannes@sipsolutions.net>
To: Amadeusz =?UTF-8?Q?S=C5=82awi=C5=84ski?=
        <amadeusz.slawinski@tieto.com>, linux-wireless@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Jan 2017 09:51:24 +0100
In-Reply-To: <1485272531-11587-1-git-send-email-amadeusz.slawinski@tieto.com> (sfid-20170124_164227_980319_47DCDD4D)
References: <1485272531-11587-1-git-send-email-amadeusz.slawinski@tieto.com>
         (sfid-20170124_164227_980319_47DCDD4D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-01-24 at 16:42 +0100, Amadeusz Sławiński wrote:
> cleanup patch to make use of ieee80211_ac_from_tid() to retrieve ac
> from
> ieee802_1d_to_ac[]

Applied.

johannes
