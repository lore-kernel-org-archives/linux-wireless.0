Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:32228 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbYIZRhU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 13:37:20 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1132795rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 10:37:19 -0700 (PDT)
Message-ID: <45e8e6c40809261037x40f6642bq1340bb0ee1e8f13b@mail.gmail.com> (sfid-20080926_193727_822756_78A01F02)
Date: Fri, 26 Sep 2008 10:37:19 -0700
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fixups for "make master iface not wireless"
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1222428894.10563.115.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222419687-7106-1-git-send-email-lrodriguez@atheros.com>
	 <1222428894.10563.115.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is it possible that further fixups are needed?  I cannot add
interfaces (for example, via iw) because doing so causes
ieee80211_change_iface() to return -ENODEV when the master interface
is looked up by __dev_get_by_index()

  -Andrey
