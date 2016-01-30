Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:34004 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbcA3STf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2016 13:19:35 -0500
Received: by mail-qg0-f51.google.com with SMTP id 6so89785737qgy.1
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jan 2016 10:19:35 -0800 (PST)
Date: Sat, 30 Jan 2016 13:19:21 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: mesh: drop write-only var mean_chain_len
Message-ID: <20160130181921.GA24370@localhost> (sfid-20160130_191939_083194_DF828FFC)
References: <1453991052-11899-1-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453991052-11899-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 28, 2016 at 09:24:12AM -0500, Bob Copeland wrote:
> mean_chain_len is copied into mesh path table
> structures, but only ever has the value 2 and
> is never read, so just remove it.

Disregard, I sent a v2 (under a different subject) where the commit log
actually makes sense.

-- 
Bob Copeland %% http://bobcopeland.com/
