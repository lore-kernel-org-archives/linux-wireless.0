Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49966 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaBKMNo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 07:13:44 -0500
Message-ID: <1392120819.4128.5.camel@jlt4.sipsolutions.net> (sfid-20140211_131347_011050_9100EB04)
Subject: Re: [PATCH] mac80211_hwsim: allow creation of single-channel radios
 with chanctx
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 11 Feb 2014 13:13:39 +0100
In-Reply-To: <1392038583-12941-1-git-send-email-luca@coelho.fi>
References: <1392038583-12941-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-02-10 at 15:23 +0200, Luciano Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Add a new HWSIM_ATTR_USE_CHANCTX attribute to the
> HWSIM_CMD_CREATE_RADIO command to allow the creation of radios with
> one channel that use channel contexts.  If this attribute is not
> present, the behaviour is the same as before (ie. single channel
> radios don't use channel contexts and multi channel radios do).

Applied

> +	if(info->attrs[HWSIM_ATTR_USE_CHANCTX])

with that fixed :)

johannes

