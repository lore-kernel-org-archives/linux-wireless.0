Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2KTJ1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 04:27:41 -0500
Message-ID: <1353403691.9399.8.camel@jlt4.sipsolutions.net> (sfid-20121120_102748_945348_23A164BC)
Subject: Re: [PATCH] mac80211: fix channel context suspend handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	sujith@msujith.org
Date: Tue, 20 Nov 2012 10:28:11 +0100
In-Reply-To: <CAB3XZEfDLV9zqbX6Q-tzY7YHtCQwQTxvPUp129d00u3K_5VOTw@mail.gmail.com> (sfid-20121120_102601_698163_6FEB6507)
References: <1353360586-32157-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEfDLV9zqbX6Q-tzY7YHtCQwQTxvPUp129d00u3K_5VOTw@mail.gmail.com>
	 (sfid-20121120_102601_698163_6FEB6507)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-20 at 11:25 +0200, Eliad Peller wrote:

> what about releasing the chanctx (drv_remove_chanctx)?

Ahrg, yes. Unapplied the patch :)

johannes

