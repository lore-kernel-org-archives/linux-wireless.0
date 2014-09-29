Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:42619 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbaI2PLe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 11:11:34 -0400
Received: by mail-wi0-f179.google.com with SMTP id d1so1309329wiv.12
        for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2014 08:11:33 -0700 (PDT)
Date: Mon, 29 Sep 2014 17:11:30 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] mac80211: minstrel_ht: add basic support for VHT rates
 <= 80MHz@NSS2
Message-ID: <20140929151130.GB28368@magnum.frso.rivierawaves.com> (sfid-20140929_171145_468406_85FE93B7)
References: <1411951124-24490-1-git-send-email-karl.beldan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1411951124-24490-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unless I can spare some space in rc_stats, v2 will need an increase in
minstrel_debugfs_info buffer (ATM 1 line is > 100 chars).
 
Karl
