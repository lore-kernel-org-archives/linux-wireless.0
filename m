Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:51380 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaKHQgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2014 11:36:52 -0500
Received: by mail-ig0-f180.google.com with SMTP id h3so7041104igd.7
        for <linux-wireless@vger.kernel.org>; Sat, 08 Nov 2014 08:36:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415451582-5610-1-git-send-email-hauke@hauke-m.de>
References: <1415451582-5610-1-git-send-email-hauke@hauke-m.de>
Date: Sat, 8 Nov 2014 17:36:51 +0100
Message-ID: <CACna6rz72_CS_Zrc28qTWWeBnA=x51cBe7Pg6a3Tyt0ejUORNQ@mail.gmail.com> (sfid-20141108_173701_416557_76358916)
Subject: Re: [PATCH v2 3.18+] b43: fix NULL pointer dereference in b43_phy_copy()
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	andrey.krieger.utkin@gmail.com, v.kempter@pe.tu-clausthal.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 November 2014 13:59, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> phy_read and phy_write are not set for every phy any more sine this:
> commit d342b95dd735014a590f9051b1ba227eb54ca8f6

Looks OK, thanks for your patch!
