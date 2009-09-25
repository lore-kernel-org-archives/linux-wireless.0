Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:65355 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbZIYTLG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 15:11:06 -0400
Received: by fxm18 with SMTP id 18so2446264fxm.17
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 12:11:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890909241311j552ee33ata80ba24c386a316b@mail.gmail.com>
References: <20090924180048.14503.9579.stgit@tikku>
	 <20090924180251.14503.64152.stgit@tikku>
	 <43e72e890909241135j21f687a7oc4f929d2134b6310@mail.gmail.com>
	 <da94abde0909241210m69bd619sce62645c3aca9aae@mail.gmail.com>
	 <43e72e890909241311j552ee33ata80ba24c386a316b@mail.gmail.com>
Date: Fri, 25 Sep 2009 12:11:09 -0700
Message-ID: <da94abde0909251211x347bbd30xdfe2bd05bc1e07e5@mail.gmail.com>
Subject: Re: [PATCH 2/2] at76c50x-usb: set firmware and hardware version in
	wiphy
From: Kalle Valo <kalle.valo@iki.fi>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org, Felix Bitterli <ic.felix@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 1:11 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Sep 24, 2009 at 12:10 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
>
>> BTW, is there an easy way to get the module name for the interface?
>> That's also helpful information for the user.
>
> If you can map the interface to PCI ID then I think its possible,
> lspci -k seems to do it.

Not all drivers use PCI, we have USB, SDIO, SPI and so on.

> It would be a nice addition to iw output as well IMHO.

I agree. I'm not going to work on adding the driver name right now,
but maybe in the future.

Kalle
