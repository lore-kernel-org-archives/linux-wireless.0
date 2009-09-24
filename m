Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:54847 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZIXUMC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 16:12:02 -0400
Received: by iwn8 with SMTP id 8so1205618iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 13:12:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <da94abde0909241210m69bd619sce62645c3aca9aae@mail.gmail.com>
References: <20090924180048.14503.9579.stgit@tikku> <20090924180251.14503.64152.stgit@tikku>
	<43e72e890909241135j21f687a7oc4f929d2134b6310@mail.gmail.com>
	<da94abde0909241210m69bd619sce62645c3aca9aae@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 24 Sep 2009 13:11:46 -0700
Message-ID: <43e72e890909241311j552ee33ata80ba24c386a316b@mail.gmail.com>
Subject: Re: [PATCH 2/2] at76c50x-usb: set firmware and hardware version in
	wiphy
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, Felix Bitterli <ic.felix@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 12:10 PM, Kalle Valo <kalle.valo@iki.fi> wrote:

> BTW, is there an easy way to get the module name for the interface?
> That's also helpful information for the user.

If you can map the interface to PCI ID then I think its possible,
lspci -k seems to do it. It would be a nice addition to iw output as
well IMHO.

  Luis
