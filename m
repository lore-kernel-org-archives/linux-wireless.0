Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:50193 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab1FGTXI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2011 15:23:08 -0400
Subject: Re: [iwl4965] Microcode SW error detected
From: Paul Bolle <pebolle@tiscali.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Bernhard Schmidt <bschmidt@freebsd.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110607145435.GA5179@redhat.com>
References: <1306151106.2066.60.camel@x61.thuisdomein>
	 <201106070832.49048.bschmidt@freebsd.org>
	 <20110607145435.GA5179@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 21:23:00 +0200
Message-ID: <1307474580.2342.7.camel@x61.thuisdomein> (sfid-20110607_212312_266667_F692B693)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-07 at 16:54 +0200, Stanislaw Gruszka wrote:
> That could be useful hint, we do not scan chan by chan, but we
> have thing called "plcp check health", which "restart radio"
> by requesting one channel scan. So perhaps disabling that could
> help.

At this moment I'm interested in something (a script, some sequence of
actions, whatever) that (somewhat) reliably triggers this error. Because
right now I have no clue what triggers it.

Is your patch in that category or is it a (crude) fix? If it's a fix,
I'm not sure it is of much help at this stage.



Paul Bolle

