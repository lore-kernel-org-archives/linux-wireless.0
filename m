Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:43559 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab1AJQD3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 11:03:29 -0500
Subject: Re: [PATCH v4 00/18] AP mode support for wl12xx
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
In-Reply-To: <1293665533-7599-1-git-send-email-arik@wizery.com>
References: <1293665533-7599-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 18:03:32 +0200
Message-ID: <1294675412.1992.143.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-30 at 00:31 +0100, Arik Nemtsov wrote:
> These patches add access point mode support to the wl12xx driver.
> This mode uses a separate firmware and has a different initialization
> sequence.
> 
> In all instances, the flow has been split according to the operating
> mode of the driver (AP/STA), so as not to affect STA mode functionality.
> 
> v1->2: rebased on latest wl12xx tree
> v2->3: refactoring
> v3->4: cross-patch fix

Applied the series, thanks Arik!

-- 
Cheers,
Luca.

