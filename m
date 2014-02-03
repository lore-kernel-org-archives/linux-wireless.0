Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36969 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaBCKyX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 05:54:23 -0500
Message-ID: <1391424860.4488.6.camel@jlt4.sipsolutions.net> (sfid-20140203_115425_840496_4702646A)
Subject: Re: [PATCH] [iw] Make the build system automake based
From: Johannes Berg <johannes@sipsolutions.net>
To: Cristian =?ISO-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Feb 2014 11:54:20 +0100
In-Reply-To: <1391424732.4488.4.camel@jlt4.sipsolutions.net> (sfid-20140203_115223_694753_9E04CB22)
References: <1391319050-100614-1-git-send-email-crrodriguez@opensuse.org>
	 <1391424732.4488.4.camel@jlt4.sipsolutions.net>
	 (sfid-20140203_115223_694753_9E04CB22)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-02-03 at 11:52 +0100, Johannes Berg wrote:

> I *might* be open to switching to something like
> cmake

[...] something *sane* like cmake [...]

(FWIW, don't even argue that part about auto*, it's decidedly not sane
to have a build system that needs roughly two dozen versions installed
concurrently to build different software)

johannes

