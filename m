Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52869 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab3D2KSi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 06:18:38 -0400
Message-ID: <1367230699.8289.1.camel@jlt4.sipsolutions.net> (sfid-20130429_121841_132580_1EEB0CD5)
Subject: Re: [PATCH 1/2] mac80211: Add STBC RX flag to radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, linux@rempel-privat.de
Date: Mon, 29 Apr 2013 12:18:19 +0200
In-Reply-To: <1367226260-26755-2-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20130429_110625_498196_82A8FB5B)
References: <1367226260-26755-1-git-send-email-Wojciech.Dubowik@neratec.com>
	 <1367226260-26755-2-git-send-email-Wojciech.Dubowik@neratec.com>
	 (sfid-20130429_110625_498196_82A8FB5B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-29 at 11:04 +0200, Wojciech Dubowik wrote:
> Add rx flag to radiotap header which tells whether

Same here, you can't just randomly add something to radiotap. Go
standardise it first.

johannes

