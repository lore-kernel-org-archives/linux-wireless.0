Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab0H0TYl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 15:24:41 -0400
From: Johannes Berg <johannes@sipsolutions.net>
Reply-To: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 3/6] mac80211: simplify zero address checks
References: <20100827103553.559128239@sipsolutions.net>
	 <20100827103658.361889799@sipsolutions.net>
	  <AANLkTinDQDRZzHxjoUNWr=f6LbdRKR4nedjA-5HmKwKz@mail.gmail.com>
In-Reply-To: <AANLkTinDQDRZzHxjoUNWr=f6LbdRKR4nedjA-5HmKwKz@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 27 Aug 2010 21:24:39 +0200
Message-Id: <1282937079.1583.2.camel@Nokia-N900-51-1>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > The libertas_tf special code for zero addresses
> 
> libertas_tf? This looks like a mac80211 patch to me...

Yeah, but this mac80211 code exists only for libertas_tf.

Johannes
