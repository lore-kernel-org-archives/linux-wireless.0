Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55777 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab2LGIJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 03:09:22 -0500
Message-ID: <1354867778.9552.6.camel@jlt4.sipsolutions.net> (sfid-20121207_090934_961519_94E58F52)
Subject: Re: [RFC V3 1/2] I'dcfg80211: Move the definition of struct
 mac_address up
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev <netdev@vger.kernel.org>
Date: Fri, 07 Dec 2012 09:09:38 +0100
In-Reply-To: <1354858735.22463.31.camel@joe-AO722> (sfid-20121207_063922_600678_E7195284)
References: <1354853850-10537-1-git-send-email-vthiagar@qca.qualcomm.com>
	 <1354858735.22463.31.camel@joe-AO722>
	 (sfid-20121207_063922_600678_E7195284)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-06 at 21:38 -0800, Joe Perches wrote:
> On Fri, 2012-12-07 at 09:47 +0530, Vasanthakumar Thiagarajan wrote:
> > struct mac_address will be used by ACL related configuration ops.
> 
> I'd prefer that any new code _not_ use struct mac_address
> but use u8 addr[ETH_ALEN] instead.

Passing around arrays of that is inconvenient, hence the struct.

johannes

