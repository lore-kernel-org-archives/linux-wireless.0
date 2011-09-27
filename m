Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46377 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1I0HrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 03:47:08 -0400
Subject: Re: [PATCH 1/1] rfkill: add module option to become inactive.
From: Johannes Berg <johannes@sipsolutions.net>
To: "Andrew V. Stepanov" <stanv@altlinux.org>
Cc: davem@davemloft.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Andriy Stepanov <stanv@altlinux.ru>
In-Reply-To: <1317119624-2974-1-git-send-email-stanv@altlinux.org> (sfid-20110927_083311_957911_9A044E07)
References: <1317119624-2974-1-git-send-email-stanv@altlinux.org>
	 (sfid-20110927_083311_957911_9A044E07)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 09:46:57 +0200
Message-ID: <1317109617.4082.0.camel@jlt3.sipsolutions.net> (sfid-20110927_094712_556375_1BFE201D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-09-27 at 14:33 +0400, Andrew V. Stepanov wrote:
> From: Andriy Stepanov <stanv@altlinux.ru>
> 
> Use as:
> modprobe rfkill unblocked=1
> or
> /etc/modprobe.d/options
> options rfkill unblocked=1

Apart from the obvious style problems in this patch (tons of extra
braces) I'm not convinced this is a good idea.

What problem does it solve? Why can that problem not be solved
differently with existing mechanisms (e.g. urfkilld configured to do
nothing)?

johannes

