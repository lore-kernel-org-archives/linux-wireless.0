Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37913 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380AbaCSOBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 10:01:10 -0400
Message-ID: <1395237666.4142.10.camel@jlt4.sipsolutions.net> (sfid-20140319_150116_437256_CD334B93)
Subject: Re: [PATCH 2/3] cfg80211: fix processing world regdomain when non
 modular
From: Johannes Berg <johannes@sipsolutions.net>
To: Colleen T <colleen@cozybit.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org, linux@eikelenboom.it
Date: Wed, 19 Mar 2014 15:01:06 +0100
In-Reply-To: <CANrMYP6Rvv4EBjY9-78bdm70G_3YGZFrJH9tFz5XVsbSSi-m=Q@mail.gmail.com> (sfid-20140314_213027_005689_0937166D)
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
	 <1393376982-28276-3-git-send-email-mcgrof@do-not-panic.com>
	 <1393852248.10039.5.camel@jlt4.sipsolutions.net>
	 <CANrMYP6Rvv4EBjY9-78bdm70G_3YGZFrJH9tFz5XVsbSSi-m=Q@mail.gmail.com>
	 (sfid-20140314_213027_005689_0937166D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-14 at 13:30 -0700, Colleen T wrote:
> Hi guys,
> 
> This commit -- 5a970df8990d173e7e4092952f2e3da1de69b27d -- is causing
> a regression on mac80211-next/master in our mesh test framework on
> qemu.  We are using cfg80211 as a module.

I'm reverting that commit.

johannes

