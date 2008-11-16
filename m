Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3247 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbYKPFz7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 00:55:59 -0500
Date: Sun, 16 Nov 2008 00:55:14 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Dan McGee <dpmcgee@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
Message-ID: <20081116055514.GB14126@hash.localnet> (sfid-20081116_065602_065979_D5F22D34)
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com> <43e72e890811132217k160db63ch77e7d03c38e81d5f@mail.gmail.com> <b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com> <449c10960811151811s32fdd2b6p361d2ec9dd674fcc@mail.gmail.com> <449c10960811151838m3fcae118n65139be735c10665@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <449c10960811151838m3fcae118n65139be735c10665@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 15, 2008 at 08:38:32PM -0600, Dan McGee wrote:
> I should clarify here- the real bug was when trying to access
> '->driver', as we got the 00000001 poison pointer returned (this is a
> poison value, right?).

Not sure it's a poison, but it's definitely a bad value.  The good news 
is that with your config and compat-wireless I can easily reproduce this 
now.  So hopefully I'll be able to pin something down soon.

-- 
Bob Copeland %% www.bobcopeland.com

