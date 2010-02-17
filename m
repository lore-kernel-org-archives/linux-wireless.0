Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:42623 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658Ab0BQNZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 08:25:34 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] nl80211: add power save commands
Date: Wed, 17 Feb 2010 14:21:52 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kalle.valo@iki.fi>
References: <20100216201026.25148.40799.stgit@tikku> <201002170835.00109.holgerschurig@gmail.com> <1266395616.4006.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1266395616.4006.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <201002171421.52329.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> But if you wish you can emulate that with rate mask settings.
> Not in cfg80211 though please.

No, modulaton != rates.

AFAIK you can run 1 MB/s with both CCK (802.11b) and with OFDM 
(802.11g), but they generate different wave-forms.


With madwifi cards I had circumstances where the absolute range 
of CCK was higher than that of OFDM, even when limiting to 1, 2, 
5.5, 11 MB/s. This didn't happen in every storage warehouse, but 
it happens. I don't have a clue why, the theory --- as far as I 
understand it, which isn't far --- tells me otherwise.

-- 
http://www.holgerschurig.de
