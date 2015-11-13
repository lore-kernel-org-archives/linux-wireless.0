Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57505 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162AbbKMJzg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 04:55:36 -0500
Message-ID: <1447408532.3271.12.camel@sipsolutions.net> (sfid-20151113_105545_058234_AB4F7B0D)
Subject: Re: [RFC v5 4/5] mac80211: use Kconfig counters to elide
 unnecessary code
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Marek <mmarek@suse.com>
Date: Fri, 13 Nov 2015 10:55:32 +0100
In-Reply-To: <1447408352.3271.11.camel@sipsolutions.net> (sfid-20151113_105242_906025_8ED4659E)
References: <1447365652-23716-1-git-send-email-johannes@sipsolutions.net>
	 <1447365652-23716-5-git-send-email-johannes@sipsolutions.net>
	 <CAGRGNgUr=ygLh-B1ZZ5ojPeRJVXCEbY3dniAtXZq_29DZzqjCw@mail.gmail.com>
	 (sfid-20151113_104917_989701_911D22D2) <1447408352.3271.11.camel@sipsolutions.net>
	 (sfid-20151113_105242_906025_8ED4659E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-11-13 at 10:52 +0100, Johannes Berg wrote:
> 
>                        (CONFIG_MAC80211_DRIVER_NO_HWFLAGS > 0),      

Of course not, it's a bool. Anyway, thanks!

johannes
> 
