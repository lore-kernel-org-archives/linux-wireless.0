Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43838 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab3BDRzR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 12:55:17 -0500
Message-ID: <1360000536.17993.24.camel@jlt4.sipsolutions.net> (sfid-20130204_185523_904489_EE5C6F90)
Subject: Re: [PATCH] mac80211: Fix PN corruption in case of multiple virtual
 interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Amit Shakya <amit.shakya@stericsson.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 04 Feb 2013 18:55:36 +0100
In-Reply-To: <201302041844.44436.chunkeey@googlemail.com> (sfid-20130204_184447_354638_056330FF)
References: <1359976737-28059-1-git-send-email-amit.shakya@stericsson.com>
	 <201302041814.11894.chunkeey@googlemail.com>
	 <1359999018.17993.13.camel@jlt4.sipsolutions.net>
	 <201302041844.44436.chunkeey@googlemail.com>
	 (sfid-20130204_184447_354638_056330FF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-04 at 18:44 +0100, Christian Lamparter wrote:

> See the attached patch. It compiles, but I can't test it right now.

> mac80211: protect rx-path with spinlock
> 
[...]

Looks good to me. Amit, can you test it please?

johannes


