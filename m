Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47263 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab0KLQtm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 11:49:42 -0500
Subject: Re: Distinguishing wrong password from other failure to connect?
From: Johannes Berg <johannes@sipsolutions.net>
To: Josh Lehan <krellan@krellan.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4CDCEBE9.8060905@krellan.com>
References: <4CDCEBE9.8060905@krellan.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 08:51:05 -0800
Message-ID: <1289580665.3736.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-11 at 23:25 -0800, Josh Lehan wrote:
> This seems to be a common problem, because on many distributions, I see
> NetworkManager constantly popping up the password entry box whenever an
> association fails, when the user already knows the password is correct
> (and in fact has entered it into the box already, as it's pre-filled in
> the box, albeit starred out).

It should only have that issue with WEP (which you shouldn't be using
anyway) and even then only when shared key auth is not available.
Otherwise, the supplicant should have enough info about the failure.

johannes

