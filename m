Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:53854 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597AbZHGPfe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 11:35:34 -0400
From: Frans Pop <elendil@planet.nl>
To: Chris Clayton <chris2553@googlemail.com>
Subject: Re: ath5k - strange regulatory domain change
Date: Fri, 7 Aug 2009 17:35:32 +0200
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c6b1100b0908070350t3101030bs4b3d2e7485ad9aee@mail.gmail.com> <200908071324.45269.elendil@planet.nl> <200908071324.45269.elendil@planet.nl> <c6b1100b0908070556sb3f4f80sc757d8b100cbcb3c@mail.gmail.com>
In-reply-To: <c6b1100b0908070556sb3f4f80sc757d8b100cbcb3c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200908071735.33428.elendil@planet.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chris Clayton wrote:
> That's a regression in my book. Oh well! I do have the iw and crda
> applications installed, so I've taken that route of setting the
> regulatory domain to GB.

Somewhere in that thread I pointed to Luis explained that using the 
cfg80211 module parameter is deprecated if you're using those 
applications. So I think that is indeed the correct way to solve it.

If you did not have those applications installed, the GB setting from the 
module parameter would still be honored.

Cheers,
FJP
