Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:49051 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757795Ab3BAV6K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 16:58:10 -0500
Message-ID: <1359755886.17807.12.camel@joe-AO722> (sfid-20130201_225828_001427_8F17CA9B)
Subject: Re: [PATCH 0/6] Fix a number of warnings that show up when using
 "make W=1"
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Date: Fri, 01 Feb 2013 13:58:06 -0800
In-Reply-To: <1359736827-30977-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1359736827-30977-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-01 at 10:40 -0600, Larry Finger wrote:
> Several of the rtlwifi family of drivers show warnings when W=1 is added to
> the make command. This set of patches fixes all ot them. None of them are
> serious and they may be applied to some future kernel.

Do these really need fixing?
I think Linus' email from awhile back is still reasonable.

https://lkml.org/lkml/2007/2/9/183


