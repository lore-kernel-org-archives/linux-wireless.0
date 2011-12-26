Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm15.bullet.mail.ukl.yahoo.com ([217.146.183.189]:39948 "HELO
	nm15.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753377Ab1LZWSB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Dec 2011 17:18:01 -0500
From: Marek Lindner <lindner_marek@yahoo.de>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: Re: [PATCH] mac80211: fix kernel panic in IBSS due to a regression
Date: Tue, 27 Dec 2011 06:11:12 +0800
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1324876409-2031-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1324876409-2031-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201112270611.13380.lindner_marek@yahoo.de> (sfid-20111226_231822_215001_C454902D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, December 26, 2011 13:13:29 Mohammed Shafi Shajakhan wrote:
> kernel panic occurs when we create an IBSS mode and leave it for
> sometime without any joiner and this is introduced by the
> commit ec2b774e7c91094d8c00de579646f1162b87b01e where we don't
> put proper braces for 'list_for_each_entry_safe' and we pass an
> invalid 'sta' pointer to __sta_info_destroy

I sw this crash too but did not dive into it yet. Thanks!
Some things are too simple ..  :-)

Cheers,
Marek
