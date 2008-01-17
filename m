Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:42272 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYAQPcb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2008 10:32:31 -0500
Received: by rv-out-0910.google.com with SMTP id k20so584341rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2008 07:32:30 -0800 (PST)
Message-ID: <c85cb4470801170732y4e0c1921n6e66836f7ebf495d@mail.gmail.com> (sfid-20080117_153252_991354_BDA3D8C0)
Date: Thu, 17 Jan 2008 17:32:30 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix RCU locking in __ieee80211_rx_handle_packet
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1200516460.8007.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1200516460.8007.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> sparse actually detected this.... oh well
>

Arrrr... i did the re-structuring of Rx flow and forgot to sparse.
I'll issue a patch to clean up the warnings.
