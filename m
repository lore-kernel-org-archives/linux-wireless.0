Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61907 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab2HBGBl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 02:01:41 -0400
Received: by wgbdr13 with SMTP id dr13so7617838wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Aug 2012 23:01:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5019EC7D.5030208@01019freenet.de>
References: <5016F03F.1020508@t-online.de>
	<5016F59E.9070101@01019freenet.de>
	<CANUX_P2CZW5ji--KkXoyBZUuZfOqkPk_A8Ui9tw4rNeuY=mebQ@mail.gmail.com>
	<5019EC7D.5030208@01019freenet.de>
Date: Thu, 2 Aug 2012 09:01:39 +0300
Message-ID: <CANUX_P10yfdy+d9txsp1RV9niKex_5WAr0VFsjsMiPosv6M+mA@mail.gmail.com> (sfid-20120802_080212_682804_8C7574D2)
Subject: Re: No WLAN on DELL XPS L702x with Ubuntu 12.04LTS (64Bit)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "Ch. Hanisch" <ch-hanisch@t-online.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> He wrote, too, that the installation of compat-wireless (unfortunately,
> he didn't told me which version), didn't changed the situation.
>
> I attached for him the output of
> options iwlwifi debug=0xffffffff
>
> The last part of it:

what about the logs *before* that?

>
> [  675.594758] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
> [  675.594863] iwlwifi 0000:03:00.0: Unable to initialize device.
>
> I hope this debug output can help you to find the problem!

Sorry, it can't
