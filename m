Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60358 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934AbaJXJxb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 05:53:31 -0400
Message-ID: <1414144408.1934.1.camel@jlt4.sipsolutions.net> (sfid-20141024_115334_763902_66B2D8D8)
Subject: Re: [PATCH v2 2/2] iw: add vendor send command
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 24 Oct 2014 11:53:28 +0200
In-Reply-To: <1410778078-25244-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140915_124826_584469_C9D374FB)
References: <1410778078-25244-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140915_124826_584469_C9D374FB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-09-15 at 12:47 +0200, Janusz Dziedzic wrote:
> This allow to send vendor data to the driver.
> This command required OUI and SUBCMD parameters.
> 
> Also optional DATA parameter could be used:

Applied, sorry for the delay.

johannes

