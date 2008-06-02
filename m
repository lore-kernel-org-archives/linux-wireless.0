Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms5.Sony.CO.JP ([211.125.136.201]:57300 "EHLO ms5.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbYFBEAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 00:00:16 -0400
Date: Mon, 02 Jun 2008 12:59:31 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH 2/3] PS3: gelic: Use the new PMK interface in the gelic driver
Cc: linux-wireless@vger.kernel.org, geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <1212170022.8178.31.camel@localhost.localdomain>
References: <20080530164511.474A.40F06B3A@sm.sony.co.jp> <1212170022.8178.31.camel@localhost.localdomain>
Message-Id: <20080602124920.4768.40F06B3A@sm.sony.co.jp> (sfid-20080602_060022_783887_BE50B520)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 30 May 2008 13:53:42 -0400
Dan Williams <dcbw@redhat.com> wrote:
> 
> Awesome; I assume that once the 4WAY_HANDSHAKE bits get in you can
> switch over to the WEXT driver for wpa_supplicant, right?
> 
> Acked-by: Dan Williams <dcbw@redhat.com>

Yes, that's definitely the primary reason for this change.


-- 
Masakazu Mokuno

