Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:44004 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753539AbZCQSQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 14:16:20 -0400
Message-ID: <49BFE8E3.1050502@lwfinger.net> (sfid-20090317_191622_968479_3B02F03A)
Date: Tue, 17 Mar 2009 13:16:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Possible circular locking problem
References: <49BFCCC5.9080500@lwfinger.net> <20090317170530.GE6737@tuxdriver.com>
In-Reply-To: <20090317170530.GE6737@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> I think Johannes may have already posted a patch that addresses the
> cfg80211 vs. rtnl locking (or I could be wrong).  I'll try to get
> another round of patches merged sometime today.

Thanks for the info. I'll watch for locking updates.

Larry
