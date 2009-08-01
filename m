Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:36648 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZHAIYc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 04:24:32 -0400
Received: by bwz19 with SMTP id 19so1568214bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2009 01:24:31 -0700 (PDT)
Message-ID: <4A73FBBD.3070507@gmail.com>
Date: Sat, 01 Aug 2009 10:24:29 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, proski@gnu.org
Subject: Re: [PATCH 4/4] ath5k: Use SWI to trigger calibration
References: <20090731181020.GE7963@makis> <20090801054649.GA8390@makis>	 <4A73FA8D.5030804@gmail.com> <1249114918.26584.18.camel@johannes.local>
In-Reply-To: <1249114918.26584.18.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/01/2009 10:21 AM, Johannes Berg wrote:
> Actually, jiffies are unsigned long

Yeah, this is what I meant. I agree I messed it up when I didn't write
the unsigned explicitly. It might have been confusing, thanks for
pointing out.
