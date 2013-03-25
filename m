Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35645 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab3CYUwO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 16:52:14 -0400
Received: by mail-wi0-f169.google.com with SMTP id c10so2682076wiw.2
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2013 13:52:13 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	fengguang.wu@intel.com, Karl Beldan <karl.beldan@gmail.com>
Subject: [PATCH v2 0/3] mac80211: Enable VHT for non chanctxes drivers
Date: Mon, 25 Mar 2013 21:51:42 +0100
Message-Id: <1364244705-31108-1-git-send-email-karl.beldan@gmail.com> (sfid-20130325_215218_754170_D748ED00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Fengguang's build with v1 yields kernel-doc warnings.
This v2 replaces the @channel+@channel_type kernel-doc entries in 
struct ieee80211_conf with an @chandef.

 
Karl
