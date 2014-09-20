Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:48026 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbaITNUg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2014 09:20:36 -0400
MIME-Version: 1.0
In-Reply-To: <1411218125-32670-1-git-send-email-hauke@hauke-m.de>
References: <1411218125-32670-1-git-send-email-hauke@hauke-m.de>
Date: Sat, 20 Sep 2014 15:20:35 +0200
Message-ID: <CACna6rwozvugsSQDf_JQ=rj_PDNghvXc=JmvRAJeWp4gFdfuVg@mail.gmail.com> (sfid-20140920_152045_474264_EBB7AE44)
Subject: Re: [PATCH v3 1/2] bcma: register bcma as device tree driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Arend Van Spriel <arend@broadcom.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 September 2014 15:02, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This driver is used by the bcm53xx ARM SoC code. Now it is possible to
> give the address of the chipcommon core in device tree and bcma will
> search for all the other cores.

Looks fine, thanks!
