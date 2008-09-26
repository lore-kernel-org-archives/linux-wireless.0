Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:34068 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbYIZRkY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 13:40:24 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1133903rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 10:40:23 -0700 (PDT)
Message-ID: <45e8e6c40809261040k2aa053bap178bbfc55d66d31f@mail.gmail.com> (sfid-20080926_194029_125476_4B54BF2A)
Date: Fri, 26 Sep 2008 10:40:23 -0700
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fixups for "make master iface not wireless"
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <45e8e6c40809261037x40f6642bq1340bb0ee1e8f13b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222419687-7106-1-git-send-email-lrodriguez@atheros.com>
	 <1222428894.10563.115.camel@johannes.berg>
	 <45e8e6c40809261037x40f6642bq1340bb0ee1e8f13b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ah, I see now that I can add interface on the non-master intefaces
(ex: wlan0), so that's probably the intention.  Thanks,

  -Andrey
