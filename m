Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58652 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbaH2LOX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 07:14:23 -0400
Message-ID: <1409310861.4577.20.camel@jlt4.sipsolutions.net> (sfid-20140829_131427_030691_90EBDECA)
Subject: Re: [PATCH 2/2] iw: add vendor send command
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 29 Aug 2014 13:14:21 +0200
In-Reply-To: <1409126309-4052-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140827_095850_213527_DF22B42F)
References: <1409126309-4052-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1409126309-4052-2-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140827_095850_213527_DF22B42F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-08-27 at 09:58 +0200, Janusz Dziedzic wrote:

> cat data.bin | iw wlan0 send oui subcmd

Interesting approach, but I'm not sure I like the stdin? Maybe you could
make it an optional <filename|-|hex string> argument instead (- for
stdin)?

johannes

