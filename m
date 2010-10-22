Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42299 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab0JVUZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 16:25:14 -0400
Received: by eye27 with SMTP id 27so1617471eye.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 13:25:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1287779045-20257-1-git-send-email-zajec5@gmail.com>
References: <1287779045-20257-1-git-send-email-zajec5@gmail.com>
Date: Fri, 22 Oct 2010 22:25:13 +0200
Message-ID: <AANLkTikQa0EtMPbzVrvHeg7ZgcXCyZnk1Ff=PvOXg+9S@mail.gmail.com>
Subject: Re: [PATCH] b43: rfkill: use status register based on core revision
 not (PHY's)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 22 października 2010 22:24 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> This makes my N-PHY radio at least running (no scanning results so far). The
> same register is used by wl on this device.

John, if you care you can move left opening brace in subject to look
as following:
(not PHY's)

-- 
Rafał
