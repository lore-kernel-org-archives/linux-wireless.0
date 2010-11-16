Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44906 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823Ab0KPWWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 17:22:35 -0500
Subject: Re: [PATCH] iw: Resolve namespace clash between station plink and
 vlan commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: nbd@openwrt.org, linux-wireless@vger.kernel.org
In-Reply-To: <1289867251-21559-1-git-send-email-javier@cozybit.com>
References: <1289867251-21559-1-git-send-email-javier@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 14:24:06 -0800
Message-ID: <1289946246.3673.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-15 at 16:27 -0800, Javier Cardona wrote:
> This patch: http://osdir.com/ml/linux-wireless/2009-11/msg00981.html
> kicked the command to manage mesh plinks into non-existence.  Here we
> bring it back under a different name.

I'll happily take this, but would you prefer to have the other one
backed out instead?

johannes

