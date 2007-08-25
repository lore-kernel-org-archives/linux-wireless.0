Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50887
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbXHYADx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 20:03:53 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: Re: b43: Copy MAC address to local struct
Date: Sat, 25 Aug 2007 02:03:29 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <200708250200.52650.mb@bu3sch.de>
In-Reply-To: <200708250200.52650.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708250203.30464.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 25 August 2007, Michael Buesch wrote:
> We must copy the MAC addresses to a local struct, as we
> don't own the original pointer from mac80211 and don't
> know how mac80211 might mess with it while we are using it.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> Cc: Larry Finger <larry.finger@lwfinger.net>

Whoops, seems I already sent this one yesterday. Sorry.

