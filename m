Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36966 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaBCKwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 05:52:20 -0500
Message-ID: <1391424732.4488.4.camel@jlt4.sipsolutions.net> (sfid-20140203_115223_694753_9E04CB22)
Subject: Re: [PATCH] [iw] Make the build system automake based
From: Johannes Berg <johannes@sipsolutions.net>
To: Cristian =?ISO-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Feb 2014 11:52:12 +0100
In-Reply-To: <1391319050-100614-1-git-send-email-crrodriguez@opensuse.org>
References: <1391319050-100614-1-git-send-email-crrodriguez@opensuse.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-02-02 at 05:30 +0000, Cristian Rodríguez wrote:
> Simply run autoreconf -fiv to use.

Funny, but no. There's no "simply" in auto*shit.

> Should make libnl selection easier and in particular make
> distribution packagers significantly less grumpy as "hand written"
> makefiles are a permanent maintenance burden.

Too bad for them. Feel free to suggest other improvements, but I'm not
switching to auto*shit. I *might* be open to switching to something like
cmake, although I think it's pretty much overkill.

johannes


