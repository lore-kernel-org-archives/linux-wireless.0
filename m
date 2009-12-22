Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51733 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbZLVH0o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 02:26:44 -0500
Received: by ewy19 with SMTP id 19so4969261ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 23:26:43 -0800 (PST)
To: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] wl1271: add testmode support
References: <20091221120745.18850.67739.stgit@tikku>
	<20091221123632.18850.74951.stgit@tikku>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 22 Dec 2009 09:26:38 +0200
In-Reply-To: <20091221123632.18850.74951.stgit@tikku> (Kalle Valo's message of "Mon\, 21 Dec 2009 14\:36\:32 +0200")
Message-ID: <87tyvjxydt.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@nokia.com> writes:

> +	skb = cfg80211_testmode_alloc_reply_skb(wl->hw->wiphy, sizeof(*cmd));

I believe this should use nla_total_size().

-- 
Kalle Valo
