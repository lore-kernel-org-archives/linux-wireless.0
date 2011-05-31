Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm22-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.126]:44067 "HELO
	nm22-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751368Ab1EaIBw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 04:01:52 -0400
Message-ID: <802107.19454.qm@web161618.mail.bf1.yahoo.com> (sfid-20110531_100157_786160_5435DCD1)
Date: Tue, 31 May 2011 01:01:51 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [RFC PATCH 03/27] zd1211rw: include mac80211.h from zd_chip.h
To: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>
Cc: jussi.kivilinna@mbnet.fi
In-Reply-To: <20110529200417.16479.30806.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Date: Sunday, May 29, 2011, 11:04 PM
> zd_chip.h contains one function with
> a pointer to ieee80211_hw but doesn't
> include mac80211.h. As a temporary solution include
> mac80211.h to avoid
> a warning.

I'm still getting a warning with this patch. I think this happened when Jussi fixed some stuff awhile back.

In function ‘zd_mac_alloc_hw’:
drivers/net/wireless/zd1211rw/zd_mac.c:1340:7: warning: statement with no effect

Walter
