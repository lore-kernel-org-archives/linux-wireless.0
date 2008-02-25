Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:44413 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbYBYTkV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 14:40:21 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1102559rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 11:40:18 -0800 (PST)
Subject: Re: [PATCH 17/18] mac80211: mesh hwmp locking fixes
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1203966581.13162.129.camel@johannes.berg>
References: <20080223141703.194775000@sipsolutions.net>
	 <20080223142017.846789000@sipsolutions.net>
	 <1203966549.6929.4.camel@localhost>
	 (sfid-20080225_190733_174041_A31E50BE)  <1203966581.13162.129.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 11:41:56 -0800
Message-Id: <1203968516.6929.26.camel@localhost> (sfid-20080225_194027_977018_99BF45C6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-02-25 at 20:09 +0100, Johannes Berg wrote:
> Ah, but sta_info_get will require rcu locking after a few more patches
> so I now that I posted both sets this is easier (otherwise the sta info
> rcu-ification would have to add all the code and revert this patch)

You're right, just noticed the sta rcu-ification process.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


