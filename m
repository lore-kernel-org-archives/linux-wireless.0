Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:63708 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934503AbaH1Kum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 06:50:42 -0400
Received: by mail-ig0-f178.google.com with SMTP id hn18so675023igb.5
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2014 03:50:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1409149404-26856-1-git-send-email-zajec5@gmail.com>
References: <1409149404-26856-1-git-send-email-zajec5@gmail.com>
Date: Thu, 28 Aug 2014 12:50:42 +0200
Message-ID: <CACna6rzB1H3EE7fwbGiQQDETH72XWowX4jXcNmdcyA-nVzaK2g@mail.gmail.com> (sfid-20140828_125046_546190_E5ED275D)
Subject: Re: [PATCH] bcma: get & store info about flash type SoC booted from
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 August 2014 16:23, Rafał Miłecki <zajec5@gmail.com> wrote:
> We need this info to know where to look for NVRAM.

John: can you DROP it for now, please?
We have some big bcm47xx vs. bcm53xx vs. nvram discussion going on ;)
