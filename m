Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36064 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab3JBNBW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 09:01:22 -0400
Message-ID: <1380718874.13329.17.camel@jlt4.sipsolutions.net> (sfid-20131002_150126_918672_6BF511A8)
Subject: Re: [PATCH] mac80211: allow mgmt frame transmission on DFS channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 02 Oct 2013 15:01:14 +0200
In-Reply-To: <CAA2SeNLFSN0tAyABk=MoFDxS6purc6Tgx6R-U5xhuRJZRCZ6ig@mail.gmail.com> (sfid-20131002_145256_412065_96991E8A)
References: <1380545557-25103-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1380704100.13329.6.camel@jlt4.sipsolutions.net>
	 <CAA2SeN+nhLU7vGDNLJCD=UrNRSFm5hT6HGEEhUqr1kAcMF3O-A@mail.gmail.com>
	 <1380708715.13329.16.camel@jlt4.sipsolutions.net>
	 <CAA2SeNLFSN0tAyABk=MoFDxS6purc6Tgx6R-U5xhuRJZRCZ6ig@mail.gmail.com>
	 (sfid-20131002_145256_412065_96991E8A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-10-02 at 14:52 +0200, Lorenzo Bianconi wrote:
> I am not using latest mac80211/hostapd (in particular
> compat-wireless-2013-04-16/hostapd-20130807) because I have to port
> some personal stuff. In this scenario I was not able to establish an
> AP/STA connection on DFS channel. Anyway I will update these packages.

But that old hostapd doesn't support DFS to start with, does it? I'm
confused.

johannes

