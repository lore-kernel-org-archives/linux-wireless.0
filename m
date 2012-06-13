Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55245 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab2FMFxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 01:53:52 -0400
Received: by obbtb18 with SMTP id tb18so379380obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 22:53:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339566003.4519.1.camel@jlt3.sipsolutions.net>
References: <1339533801-32016-1-git-send-email-c_tpeder@qca.qualcomm.com>
	<1339566003.4519.1.camel@jlt3.sipsolutions.net>
Date: Wed, 13 Jun 2012 07:53:51 +0200
Message-ID: <CAOpc7mEZ3Wd2JajqTpj+tZXVyE_QC1=xS3gXF9eFjmCdTu8Xug@mail.gmail.com> (sfid-20120613_075355_808318_C4E4BED0)
Subject: Re: [PATCH] nl80211: specify RSSI threshold when scanning
From: Holger Schurig <holgerschurig@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <c_tpeder@qca.qualcomm.com>,
	kvalo@qca.qualcomm.com, ath6kl-devel@qualcomm.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

@NL80211_ATTR_SCHED_SCAN_MATCH_RSSI

I'd also move around "SCHED" and "ATTR". Look at the attribute names
above or below it, then it's more obvious:

NL80211_SCHED_SCAN_MATCH_ATTR_SSID
NL80211_ATTR_SCHED_SCAN_MATCH_RSSI
NL80211_SCHED_SCAN_MATCH_ATTR_MAX

-- 
http://www.holgerschurig.de
