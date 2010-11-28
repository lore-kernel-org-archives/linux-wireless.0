Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50010 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0K1MBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Nov 2010 07:01:44 -0500
Received: by qyk11 with SMTP id 11so9725318qyk.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Nov 2010 04:01:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290945585-20864-3-git-send-email-zajec5@gmail.com>
References: <1290945585-20864-1-git-send-email-zajec5@gmail.com>
	<1290945585-20864-3-git-send-email-zajec5@gmail.com>
Date: Sun, 28 Nov 2010 13:01:43 +0100
Message-ID: <AANLkTinwpM_GkhA9=ScaghnXdjV+-+U67aBgpewho1=0@mail.gmail.com>
Subject: Re: [PATCH 3/4] b43: N-PHY: initialize perical variable, add missing
 call to CCA reset
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 28 listopada 2010 12:59 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> +       /* Specs don't say about reset here, but it makes wl and b43 dumps
> +          identical, it really seems wl performs this */
> +       b43_nphy_reset_cca(dev);

If someone is interested in tools, dumps, let me know.

-- 
Rafał
