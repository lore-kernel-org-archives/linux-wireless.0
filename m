Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaBUIYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 03:24:00 -0500
Message-ID: <1392971037.4346.16.camel@jlt4.sipsolutions.net> (sfid-20140221_092403_939283_E5941076)
Subject: Re: [PATCH 1/2] cfg80211: docbook: fix small formatting error
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 21 Feb 2014 09:23:57 +0100
In-Reply-To: <1392907534-14470-1-git-send-email-luca@coelho.fi>
References: <1392907534-14470-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 16:45 +0200, Luciano Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> docbook (or one of its friends) gets confused with semi-colons in the
> argument descriptions, causing it to think that the semi-colon is
> marking a new section in the description of addr_mask in wiphy struct.
> 
> Prevent this by using hyphens instead of semi-colons in the mask
> example.

Applied, thanks.

johannes

