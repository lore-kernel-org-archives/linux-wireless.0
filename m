Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53802 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab2KIPsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 10:48:01 -0500
Message-ID: <1352476116.9238.10.camel@jlt4.sipsolutions.net> (sfid-20121109_164806_024310_85E52F7A)
Subject: Re: [PATCH] iw: print the ssid when requesting device info
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 09 Nov 2012 16:48:36 +0100
In-Reply-To: <1352468278-30931-1-git-send-email-ordex@autistici.org>
References: <1352468278-30931-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-09 at 14:37 +0100, Antonio Quartulli wrote:
> The GET_INTERFACE command receives also the ssid as part of the reply.
> This patch makes iw print the ssid together with the other information
> when issuing the "iw dev $vif info" command.

Applied.

johannes

