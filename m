Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:53148 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891Ab1AMLc5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jan 2011 06:32:57 -0500
Subject: Re: [PATCH] wl12xx: don't join upon disassociation
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
CC: Luciano Coelho <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1293352070-17513-1-git-send-email-eliad@wizery.com>
References: <1293352070-17513-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 13:33:12 +0200
Message-ID: <1294918392.2064.19.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-12-26 at 09:27 +0100, Eliad Peller wrote:
> wl12xx "rejoins" upon every BSS_CHANGED_BSSID notification.
> However, there is no need to rejoin after disassociation, so just
> filter out the case when the new bssid is 00:00:00:00:00:00.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Rebased to the latest tree and applied.  Thank you!

-- 
Cheers,
Luca.

