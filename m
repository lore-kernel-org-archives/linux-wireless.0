Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:48562 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbYEOTq4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 15:46:56 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [patch] resource leak in error case in rtl8187
Date: Thu, 15 May 2008 21:46:54 +0200
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-usb@vger.kernel.org, Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andreamrl@tiscali.it>
References: <200805151617.37968.oliver@neukum.org> <20080515185724.GA17690@tuxdriver.com>
In-Reply-To: <20080515185724.GA17690@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805152146.55673.oliver@neukum.org> (sfid-20080515_214702_391557_5F6BFCF1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 15 Mai 2008 20:57:24 schrieb John W. Linville:

> Don't we need the same type of fix applied to rtl8187_iowrite_async
> as well?  Would you like to resubmit (or submit a second patch)
> with that fix included?

Indeed. A new redone patch is on the way. Please disregard the earlier patch.

	Regards
		Oliver

