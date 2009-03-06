Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:51339 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755373AbZCFAOp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 19:14:45 -0500
Message-ID: <49B06AF0.9080605@lwfinger.net> (sfid-20090306_011457_112672_89510769)
Date: Thu, 05 Mar 2009 18:14:40 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 7/7 v2] p54: initial SoftLED support
References: <200903060102.04668.chunkeey@web.de>
In-Reply-To: <200903060102.04668.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> This patch adds SoftLED support for all p54 devices.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> changes:
> 	- removed stray mutex_destroy
> 	- ratelimit "failed to LED" messages
> ---

This one and the previous patch "p54: fix race condition in memory management"
fixes my crash.

Larry
