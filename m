Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49641 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab1EXPt7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 11:49:59 -0400
Subject: Re: netlink reverts
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <BANLkTim+boto9xStdaAyWeTR1+Fw=ADjwA@mail.gmail.com> (sfid-20110521_174122_827310_AE5DEA52)
References: <1305917869.4640.15.camel@jlt3.sipsolutions.net>
	 <1305917949.4640.16.camel@jlt3.sipsolutions.net>
	 <BANLkTikjDhdYMssyivgRxAyB5-_FctQbSg@mail.gmail.com>
	 <2eafee5b7a180c891df4a9ca53e90d7d@secure.sipsolutions.net>
	 <BANLkTim+boto9xStdaAyWeTR1+Fw=ADjwA@mail.gmail.com>
	 (sfid-20110521_174122_827310_AE5DEA52)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 08:49:52 -0700
Message-ID: <1306252192.3839.1.camel@jlt3.sipsolutions.net> (sfid-20110524_175002_738785_B24A0D68)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-05-21 at 08:40 -0700, Javier Cardona wrote:

> It's ok to move the plink_state attribute.  There are only a handful
> of users of the secured mesh at this point.

Let's stick to what we have and all copy a new nl80211.h from the
current tree, I had this in iw but nobody could really be using it since
no driver has wowlan.

johannes

