Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55237 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2LUJ0o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2012 04:26:44 -0500
Message-ID: <1356082023.9580.5.camel@jlt4.sipsolutions.net> (sfid-20121221_102649_117656_84C0B99A)
Subject: Re: [PATCH] iw: print capability info for 60GHz band
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 21 Dec 2012 10:27:03 +0100
In-Reply-To: <3409795.QNLPYz7pkM@lx-vladimir>
References: <3409795.QNLPYz7pkM@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-12-17 at 13:32 +0200, Vladimir Kondratiev wrote:
> From cc320b6c4433b63f3b1641646a49c4540e8954d2 Mon Sep 17 00:00:00 2001
> From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> Date: Mon, 17 Dec 2012 13:31:36 +0200
> Subject: [PATCH] iw: print capability info for 60GHz band
> 
> On the 60GHz band, capability info defined different from .11n

I would prefer you didn't use "11ad" or "11n", in particular not "11n",
it hasn't existed for quite a while now.

Also, the 2.4/5ghz capability bits really have nothing to do with 11n
anyway.

johannes


