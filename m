Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:44758 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab2LDOxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 09:53:41 -0500
Message-ID: <1354632778.6234.3.camel@cumari.coelho.fi> (sfid-20121204_155344_838078_C70C72A2)
Subject: Re: [PATCH 04/11] wlcore/wl18xx: allow TX BA on all TIDs
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>, Eliad Peller <eliad@wizery.com>
Date: Tue, 4 Dec 2012 16:52:58 +0200
In-Reply-To: <1353945950-3899-5-git-send-email-arik@wizery.com>
References: <1353945950-3899-1-git-send-email-arik@wizery.com>
	 <1353945950-3899-5-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-26 at 18:05 +0200, Arik Nemtsov wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> In 12xx cards a FW limitation prevents us from from starting TX BA
> sessions on TIDs 6/7. This restriction does not exist for 18xx cards.
> Enable TX BA on all TIDs for them
> 
> [Arik - split Tx BA parameter between chip families. Don't change this
> setting for 12xx]
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

I have dropped this patch.  After some internal discussions, we decided
that it doesn't make sense to use BA on TIDs that require low latency.

--
Luca.

