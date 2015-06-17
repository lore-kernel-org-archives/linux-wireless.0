Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46778 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbbFQInP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:43:15 -0400
Message-ID: <1434530592.1884.10.camel@sipsolutions.net> (sfid-20150617_105619_083484_1DC6F17D)
Subject: Re: [PATCH v3] mac80211: Avoid unnecessary locking on CSA counter
 update
From: Johannes Berg <johannes@sipsolutions.net>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org, julian.calaby@gmail.com
Date: Wed, 17 Jun 2015 10:43:12 +0200
In-Reply-To: <1433934413-4713-1-git-send-email-Wojciech.Dubowik@neratec.com>
References: <1433934413-4713-1-git-send-email-Wojciech.Dubowik@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-10 at 13:06 +0200, Wojciech Dubowik wrote:
> v2: Use splitted functions instead of direct counter decrement.
> v3: Changed subject and commit message

I've applied this, but I really think you should've had a commit
message ...

johannes

