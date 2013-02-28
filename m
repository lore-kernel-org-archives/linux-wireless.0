Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55763 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758009Ab3B1WOf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 17:14:35 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UBBkI-0003Kz-3h
	for linux-wireless@vger.kernel.org; Thu, 28 Feb 2013 23:14:34 +0100
Message-ID: <1362089671.8330.8.camel@jlt4.sipsolutions.net> (sfid-20130228_231439_261809_E0B4DC27)
Subject: Re: [PATCH] wireless: remove unused VHT MCS defines
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 28 Feb 2013 23:14:31 +0100
In-Reply-To: <1361475981-19517-1-git-send-email-johannes@sipsolutions.net> (sfid-20130221_204628_512495_789D773F)
References: <1361475981-19517-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130221_204628_512495_789D773F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-21 at 20:46 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's an enum with the same values (but slightly
> different names except for NOT_SUPPORTED) that is
> actually used, so remove the defines.

Applied.

johannes

