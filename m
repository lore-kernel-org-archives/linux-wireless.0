Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35998 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbaBUI3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 03:29:07 -0500
Message-ID: <1392971338.4346.21.camel@jlt4.sipsolutions.net> (sfid-20140221_092911_162594_CA091A9A)
Subject: Re: [PATCH] mac80211: allow drivers to request SMPS off
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 21 Feb 2014 09:28:58 +0100
In-Reply-To: <1392907311-13655-1-git-send-email-luca@coelho.fi>
References: <1392907311-13655-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 16:41 +0200, Luciano Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Previously we were warning and using automatic when a driver sent an
> update request with SMPS off.  This patch makes it possible for
> drivers to disable SMPS at runtime, for whatever reason.

Applied.

johannes

