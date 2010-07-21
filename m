Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44941 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762807Ab0GUIZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 04:25:03 -0400
Subject: Re: [PATCH] iw: Add support for setting transmit power level
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1277284377-11048-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1277284377-11048-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jul 2010 10:24:57 +0200
Message-ID: <1279700697.3707.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-23 at 12:12 +0300, Juuso Oikarinen wrote:
> Add a "set txpower" option to specify the current transmit power level. Modes
> supported are automatic, fixed and limited, and the limit may be specified
> in signed mBm units.

Merged, but I fixed a few nits, please look at the new version in my git
tree.

johannes

