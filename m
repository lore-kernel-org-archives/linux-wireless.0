Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38430 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab3EXKIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 06:08:16 -0400
Message-ID: <1369390088.8290.5.camel@jlt4.sipsolutions.net> (sfid-20130524_120819_407669_0C756562)
Subject: Re: [PATCH v4 1/3] mac80211: add STBC flag for radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Date: Fri, 24 May 2013 12:08:08 +0200
In-Reply-To: <1369389945-805-1-git-send-email-linux@rempel-privat.de> (sfid-20130524_120552_318974_4993675A)
References: <1369250674.8207.26.camel@jlt4.sipsolutions.net>
	 <1369389945-805-1-git-send-email-linux@rempel-privat.de>
	 (sfid-20130524_120552_318974_4993675A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-05-24 at 12:05 +0200, Oleksij Rempel wrote:
> Some chips can tell us if received frame was
> encoded with STBC or not. To make this information available
> in user space we can use updated radiotap specification:
> http://www.radiotap.org/defined-fields/MCS
> 
> This patch will set number of STBC encoded spatial streams (Nss).
> The HAVE_STBC flag should be provided by driver.

Applied, thanks.

johannes

