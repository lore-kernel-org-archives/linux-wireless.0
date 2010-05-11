Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:36555 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932346Ab0EKJeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 05:34:18 -0400
Received: from vs3009.wh2.ocn.ne.jp (125.206.180.237)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-04963457
	for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 18:34:17 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 0/2] mac80211: antenna configuration
Date: Tue, 11 May 2010 18:34:36 +0900
References: <20100511083121.28289.96180.stgit@tt-desk> <1273567999.3669.27.camel@jlt3.sipsolutions.net>
In-Reply-To: <1273567999.3669.27.camel@jlt3.sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	holgerschurig@gmail.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201005111834.36879.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 11 May 2010 17:53:19 you wrote:
> On Tue, 2010-05-11 at 17:38 +0900, Bruno Randolf wrote:
> > i have followed holger schurig's suggestion to use a bitmap for allowed
> > antennas. when multiple antennas are selected in the bitmap, the driver
> > may use diversity. i think that this allows for the most flexible, yet
> > simple configuration of antennas, and drivers can just reject
> > configurations they cannot support. i hope that this will also be
> > generic enough for 802.11n with multiple antennas
> 
> Not sure ... 11n has antennas and chains, but people mix them up
> frequently. Does this API even make sense for 11n? Use cases? Should it
> be about *antennas*, or about *chains*?

thanks for the review! i'll resend tomorrow.

i personally don't know about 802.11n - and what i need is about *antennas* :)

bruno
