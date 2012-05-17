Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759920Ab2EQHOb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 03:14:31 -0400
Message-ID: <1337238867.4524.5.camel@jlt3.sipsolutions.net> (sfid-20120517_091434_996589_3AD4FB97)
Subject: Re: [PATCH] mac80211: Handle race condition in replay handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Amit SHAKYA <amit.shakya@stericsson.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless (linux-wireless@vger.kernel.org)"
	<linux-wireless@vger.kernel.org>
Date: Thu, 17 May 2012 09:14:27 +0200
In-Reply-To: <ECD438FDEF6BD742895E554C24725A4022946BBCB6@EXDCVYMBSTM005.EQ1STM.local>
References: <ECD438FDEF6BD742895E554C24725A4022946BBCB6@EXDCVYMBSTM005.EQ1STM.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-17 at 09:09 +0200, Amit SHAKYA wrote:
> Added fix for the issue where the Rx throughput use to get stuck,
> 
> with unicast key rotation feature enabled in the Cisco AP.

Look, resending the same patch over and over as HTML isn't going to do
you any good. Please send it as plain text so I can properly reject it.

johannes


