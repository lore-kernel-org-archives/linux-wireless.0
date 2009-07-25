Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f192.google.com ([209.85.222.192]:40692 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbZGYAvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 20:51:14 -0400
Received: by pzk30 with SMTP id 30so1275420pzk.33
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2009 17:51:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248482853-17032-1-git-send-email-lrodriguez@atheros.com>
References: <1248482853-17032-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 24 Jul 2009 17:50:54 -0700
Message-ID: <43e72e890907241750ic05b0e1t81df6ef95c7fb0d8@mail.gmail.com>
Subject: Re: [PATCH] mac80211/drivers: add new mac80211 workqueue API
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Forgot to specify the order. The order is:

1/3 mac80211: redefine usage of the mac80211 workqueue
2/3 mac80211: do not queue work after suspend in the dynamic ps timer
3/3 ath9k: cancel xmit poll work at stop() callback

  Luis
