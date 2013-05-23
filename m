Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33958 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758001Ab3EWJkY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 05:40:24 -0400
Message-ID: <1369302019.12002.0.camel@jlt4.sipsolutions.net> (sfid-20130523_114037_785508_3FE25E66)
Subject: Re: [RFC v4] cfg80211: Android P2P-Device workaround
From: Johannes Berg <johannes@sipsolutions.net>
To: YanBo <dreamfly281@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 23 May 2013 11:40:19 +0200
In-Reply-To: <CAFuUQkgTbf0959=xCUCA1AR-Vxv7Cj90GC4Ae7+BQUqme70ksQ@mail.gmail.com> (sfid-20130523_051808_029519_4702FCA4)
References: <1367238384-26722-1-git-send-email-johannes@sipsolutions.net>
	 <51823A0E.8020005@broadcom.com>
	 <1367489163.8298.2.camel@jlt4.sipsolutions.net>
	 <5182BBD4.9010701@broadcom.com>
	 <1367922058.8328.2.camel@jlt4.sipsolutions.net>
	 <CAFuUQkgTbf0959=xCUCA1AR-Vxv7Cj90GC4Ae7+BQUqme70ksQ@mail.gmail.com>
	 (sfid-20130523_051808_029519_4702FCA4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-23 at 11:18 +0800, YanBo wrote:
> After create the p2p0  wireless device. When call the
> cfg80211_conn_work

How is that getting called in the first place? I'm not saying there's no
bug, but your suggested fix is completely pointless, we shouldn't get
there.

johannes

