Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:34003 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbYGXVef (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 17:34:35 -0400
Subject: Re: [ath5k-devel] [PATCH 9/12] ath5k: Update phy calibration
	functions
From: Pavel Roskin <proski@gnu.org>
To: Nick Kossifidis <mick@madwifi.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com
In-Reply-To: <20080720034712.GI7440@makis>
References: <20080720034712.GI7440@makis>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 17:34:33 -0400
Message-Id: <1216935273.3094.14.camel@dv> (sfid-20080724_233438_043584_EDB21C45)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-07-20 at 06:47 +0300, Nick Kossifidis wrote:

> + * XXX: Since during noise floor calibration antennas are detached acording to
> + * the pattent, we should stop tx queues here.

Two spelling fixes: "according to the patent".  What patent is that?
Can we use it legally?

-- 
Regards,
Pavel Roskin
