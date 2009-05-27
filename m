Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:36362
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZE0RnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 13:43:20 -0400
Date: Wed, 27 May 2009 19:43:17 +0200
From: henk <henk@god.dyndns.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k in AP mode works!! (but sometimes with an oops, and a panic)
Message-ID: <20090527174316.GA14255@god.dyndns.org>
References: <20090524222027.GA32198@god.dyndns.org> <b6c5339f0905270550y50a925fbk4b891db8bbb9d9b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b6c5339f0905270550y50a925fbk4b891db8bbb9d9b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 27, 2009 at 08:50:19AM -0400, Bob Copeland wrote:
> Any chance you could capture the panic at hostapd shutdown via netconsole?

Sure:
  http://bugzilla.kernel.org/show_bug.cgi?id=13381#c2

regards,
Henk

