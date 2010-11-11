Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:64931 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab0KKP56 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 10:57:58 -0500
Subject: Re: [RFC 00/15] Implementation of periodic scan
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "geryk@ti.com" <geryk@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CDC0C44.6070107@ti.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
	 <4CDC0C44.6070107@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 17:57:50 +0200
Message-ID: <1289491070.1606.60.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gery,

On Thu, 2010-11-11 at 16:31 +0100, ext Gery Kahn wrote:
> The main idea is to have hw offloaded periodic scan while connected or not?

This can be used for both.  The wl1271 firmware doesn't support this
periodic scan while connected, so at least for now I'll only add support
for it when not connected.

-- 
Cheers,
Luca.

