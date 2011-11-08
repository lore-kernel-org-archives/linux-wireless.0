Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1KHIU5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 03:20:57 -0500
Subject: Re: [PATCH] Fix linking with libnl-3
From: Johannes Berg <johannes@sipsolutions.net>
To: Gilles Espinasse <g.esp@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320739783-3415-1-git-send-email-g.esp@free.fr>
References: <1320739783-3415-1-git-send-email-g.esp@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 09:20:47 +0100
Message-ID: <1320740447.4304.7.camel@jlt3.sipsolutions.net> (sfid-20111108_092059_898223_09B6DBB0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 09:09 +0100, Gilles Espinasse wrote:
> iw3.2 fail to link libnl-3.2.2 with this error
> /usr/bin/ld: cannot find -lnl-genl
> 
> Contrary to previous libnl version, on v3 there is a dedicated libnl-genl-3.0.pc file
> Simply use that.

Applied, thanks.

