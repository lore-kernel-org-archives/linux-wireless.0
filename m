Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57532 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab0ITOWT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 10:22:19 -0400
Subject: Re: [RFC] mac80211 : Fix for setting of mandatory rate flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1284992110-25460-1-git-send-email-mshajakhan@atheros.com>
References: <1284992110-25460-1-git-send-email-mshajakhan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 16:22:17 +0200
Message-ID: <1284992537.3688.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-20 at 19:45 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> 
> 	The mandatory rate flags for 'g' mode was not set.Because of
> this the basic rates for 'g' mode will not be advertised.

NACK. We've already discussed this to death before, just do it properly
with decent API for it etc.

johannes

