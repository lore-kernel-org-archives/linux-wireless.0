Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab1E3Jim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 05:38:42 -0400
Subject: Re: [rt2x00-users] [PATCH 1/3] rt2x00: Serialize TX operations on
 a queue.
From: Johannes Berg <johannes@sipsolutions.net>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTinu9dBnBdYb7_bxdVUkTfzJ2cO9OQ@mail.gmail.com> (sfid-20110530_113247_224720_43BC97D5)
References: <cover.1306586311.git.gwingerde@gmail.com>
	 <201105281647.35855.helmut.schaa@googlemail.com>
	 <4DE288DB.7040309@gmail.com>
	 <201105300955.43779.helmut.schaa@googlemail.com>
	 <1306746186.3745.1.camel@jlt3.sipsolutions.net>
	 <BANLkTinu9dBnBdYb7_bxdVUkTfzJ2cO9OQ@mail.gmail.com>
	 (sfid-20110530_113247_224720_43BC97D5)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 May 2011 11:38:37 +0200
Message-ID: <1306748317.3448.0.camel@jlt3.sipsolutions.net> (sfid-20110530_113845_568214_2A74A406)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-30 at 11:32 +0200, Gertjan van Wingerde wrote:

> As a follow-up question, is it valid that mac80211 calls the driver's
> tx function simultaneously
> for multiple frames, or are we experiencing an issue with mac80211 here?

That can happen by design, yes.

johannes

