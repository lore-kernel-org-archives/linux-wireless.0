Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44737 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbbJLHX2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:23:28 -0400
Message-ID: <1444634602.2261.0.camel@sipsolutions.net> (sfid-20151012_092337_889631_DC28B60E)
Subject: Re: [PATCH] iw: Fix memory leak in error path
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Ola Olsson <ola.olsson@sonymobile.com>
Date: Mon, 12 Oct 2015 09:23:22 +0200
In-Reply-To: <1444402362-12796-1-git-send-email-ola1olsson@gmail.com> (sfid-20151009_165349_461105_89D21B18)
References: <1444402362-12796-1-git-send-email-ola1olsson@gmail.com>
	 (sfid-20151009_165349_461105_89D21B18)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-10-09 at 16:52 +0200, Ola Olsson wrote:
> The leak is present if malloc fails after requesting
> a scan with ies or meshid as input.
> 
Applied, thanks!

johannes
