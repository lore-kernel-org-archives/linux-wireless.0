Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:38116 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757195Ab2CAJAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 04:00:05 -0500
Received: by obbuo6 with SMTP id uo6so107168obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2012 01:00:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201202292351.23306.chunkeey@googlemail.com>
References: <1330548008-2120-1-git-send-email-jcmvbkbc@gmail.com>
	<201202292351.23306.chunkeey@googlemail.com>
Date: Thu, 1 Mar 2012 12:00:04 +0300
Message-ID: <CAMo8BfKjqM=8Ex5LhBsZvdhXcGQVvr0p5X5b+kUfKkcMyL1=Rg@mail.gmail.com> (sfid-20120301_100012_938176_0AE5F196)
Subject: Re: [PATCH] p54spi: Release GPIO lines and IRQ on error in p54spi_probe
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, chunkeey@web.de,
	larry.finger@lwfinger.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> But I noticed something else... We never free the firmware
> in the p54spi_probe errorpath either.

Firmware loading is going to change anyway.

-- 
Thanks.
-- Max
