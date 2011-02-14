Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44256 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1BNVDl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 16:03:41 -0500
Received: by bwz15 with SMTP id 15so5902545bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 13:03:40 -0800 (PST)
Date: Tue, 15 Feb 2011 00:03:35 +0300
From: Stanislav Fomichev <kernel@fomichev.me>
To: Roland Vossen <rvossen@broadcom.com>
Cc: Dan Carpenter <error27@gmail.com>, "s@fomichev.me" <s@fomichev.me>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] brcm80211: remove multiple calls to wl_release_fw
Message-ID: <20110214210335.GA26387@sdf-MacBook>
References: <20110212150033.GA1941@sdf-MacBook>
 <4D598993.4020900@broadcom.com>
 <20110214202249.GK4384@bicker>
 <4D59934D.2020600@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D59934D.2020600@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

> I already had a patch in the making that is a superset of
> Stanislav's patch. It fixes the leak issue. I agreed with
> Stanislav's patch since, I made the same (but: more) changes.
> Stanislav, can we agree that we wait for my patch (I plan on
> delivering this tomorrow) ?
It's alright with me. I just wanted to point out an error; so I can wait
for a better fix.

-- 
	Stas
