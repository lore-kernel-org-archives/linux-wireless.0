Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm5-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.150]:31662 "HELO
	nm5-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756732Ab1F0GCl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 02:02:41 -0400
Message-ID: <1309154559.42854.YahooMailClassic@web161619.mail.bf1.yahoo.com> (sfid-20110627_081211_869707_CE7391AB)
Date: Sun, 26 Jun 2011 23:02:39 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [PATCH] nl80211: use netlink consistent dump feature for BSS dumps
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1309007227.4317.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

This patch breaks a compilation of a compat-wireless tar ball:

nl80211.c:3641:2: error: implicit declaration of function ‘genl_dump_check_consistent’

&

nl80211.c:3731:4: error: ‘struct netlink_callback’ has no member named ‘seq’


Walter
