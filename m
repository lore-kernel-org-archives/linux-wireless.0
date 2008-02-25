Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:7067 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbYBYTuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 14:50:08 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2079110wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 11:50:08 -0800 (PST)
Subject: Re: [PATCH 11/13 v2] o11s: support for on-demand Hybrid Wireless
	Mesh Protocol
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1203968312.13162.142.camel@johannes.berg>
References: <47be77ee.02098c0a.5eba.ffff81ef@mx.google.com>
	 (sfid-20080222_072128_730595_F951750B)  <1203697819.7082.75.camel@johannes.berg>
	 <1203967829.6929.16.camel@localhost>
	 (sfid-20080225_192854_280269_CEC357A7)  <1203967819.13162.136.camel@johannes.berg>
	 <1203968210.6929.22.camel@localhost>
	 (sfid-20080225_193515_727081_D7673A7D)  <1203968312.13162.142.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 11:51:47 -0800
Message-Id: <1203969107.6929.37.camel@localhost> (sfid-20080225_195028_490827_FEB477BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-02-25 at 20:38 +0100, Johannes Berg wrote:
> Huh. The draft says something like
> 
> "includes frame headers, training sequences, access protocol frames,
> etc."
> 
> That doesn't seem to depend on the hardware but rather on the PHY type
> used, i.e. whether you have short/long preamble or 5GHz etc. Am I
> misunderstanding it?

You are right, I assumed some of those values may vary among different
hardware but have not going very deep about how to compute them.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


