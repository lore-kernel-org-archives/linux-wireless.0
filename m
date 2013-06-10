Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:51646 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3FJJoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jun 2013 05:44:09 -0400
Received: by mail-ob0-f171.google.com with SMTP id dn14so9725775obc.2
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jun 2013 02:44:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1370797183-5510-1-git-send-email-hauke@hauke-m.de>
References: <1370797183-5510-1-git-send-email-hauke@hauke-m.de>
Date: Mon, 10 Jun 2013 11:44:08 +0200
Message-ID: <CACna6rxBDFNXG2P4cg60DRYsTHrWMWvuL+L58zWM5k+T36ctFQ@mail.gmail.com> (sfid-20130610_114412_047348_24AE211D)
Subject: Re: [PATCH 1/2] bcma: activate PCI host option by default
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/6/9 Hauke Mehrtens <hauke@hauke-m.de>:
> Most users are using bcma with a PCIe card, activate support for
> this by default.

Both look sane, thanks.

-- 
Rafał
