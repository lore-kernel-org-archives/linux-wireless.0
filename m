Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:33996 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3LDB0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 20:26:23 -0500
Received: by mail-vc0-f173.google.com with SMTP id ia6so10656609vcb.18
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 17:26:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386075017.4393.11.camel@jlt4.sipsolutions.net>
References: <1385971550-4892-1-git-send-email-yeohchunyeow@gmail.com>
	<1386075017.4393.11.camel@jlt4.sipsolutions.net>
Date: Wed, 4 Dec 2013 09:26:22 +0800
Message-ID: <CAEFj984xLXHCLoXUrevEdaeFyC1qGq5T9Zt9MPf5kYj7WZUNCA@mail.gmail.com> (sfid-20131204_022626_386799_36C0069E)
Subject: Re: [PATCH] nl80211: allow the use of DFS channel in mesh
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	"distro11s@cozybit.com" <distro11s@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This seems pretty pointless right now? There's nothing supporting it, is
> there?
>
I have currently extended the iw to trigger the CAC on DFC channel
using NL80211_CMD_RADAR_DETECT. But not able to join mesh on DFS even
it is clear.

So this patch at least allows us to trigger beaconing and bring up the
mesh on DFS channel.

-----
Chun-Yeow
