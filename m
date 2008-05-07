Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:63528 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbYEGVcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 17:32:23 -0400
Received: by wf-out-1314.google.com with SMTP id 27so431267wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2008 14:32:20 -0700 (PDT)
Subject: Re: [PATCH 4/4 (optional)][MAC80211]: Brush up error paths in
	mesh_path_add.
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pavel Emelyanov <xemul@openvz.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	David Miller <davem@davemloft.net>,
	linux-wireless@vger.kernel.org,
	Linux Netdev List <netdev@vger.kernel.org>
In-Reply-To: <1210085880.13316.31.camel@johannes.berg>
References: <482070F7.5060506@openvz.org>
	 <1210085880.13316.31.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 07 May 2008 14:32:15 -0700
Message-Id: <1210195935.6666.1.camel@localhost> (sfid-20080507_233129_441392_DA726C34)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-05-06 at 16:58 +0200, Johannes Berg wrote:
> Looks all (all four patches) good to me, Luis?

Looks good to me too, thanks for the fixes Pavel.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


