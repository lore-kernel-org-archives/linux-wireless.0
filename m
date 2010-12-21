Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40514 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757569Ab0LUA3W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 19:29:22 -0500
Received: by qyj19 with SMTP id 19so4657090qyj.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 16:29:21 -0800 (PST)
Message-ID: <4D0FF4DC.4010409@lwfinger.net>
Date: Mon, 20 Dec 2010 18:29:16 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: Re: [PATCH] rtl818x: move rtl8180 and rtl8187 to separate subdirectories
References: <1292876551-26749-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1292876551-26749-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2010 02:22 PM, John W. Linville wrote:
> These drivers share one header file, but nothing else.  Worse, both
> drivers use the rtl8225 part with different register settings.  The
> results has been some ugly naming -- let's simplify that.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---

This is a good time to change this as I have heard from Realtek that their
RTL8187SE driver that uses mac80211 is running, but not yet stable. When it is,
a decision can be made if it should be in .../rtl818x/rtl8187/ or
.../rtl818x/rtl8187se/.

The new driver will also allow the staging driver to be removed.

Larry

