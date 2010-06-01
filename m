Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:53539 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756308Ab0FAPpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 11:45:52 -0400
Message-ID: <4C052B27.50907@openwrt.org>
Date: Tue, 01 Jun 2010 17:45:43 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: doddel <subscriptions@stroomer.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: mac80211 rx.c: in recent builds bridging between stations associated
 to an AP does not work
References: <loom.20100531T230843-554@post.gmane.org> <loom.20100601T173508-447@post.gmane.org>
In-Reply-To: <loom.20100601T173508-447@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-06-01 5:38 PM, doddel wrote:
> The effect may be caused by the newly introduced capability to set the
> DO_NOT_BRIDGE parameter via nl80211 (thanks for that !).
> The user-space tool iw however does not yet support setting this parameter. 
So do you mean that you enabled this option in your wireless config and
now it took effect?
Or did you mean that you did not enable this option, however for some
reason it's still active even though it should not be?

- Felix
