Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:49984 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbZCNGur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 02:50:47 -0400
Received: by fxm24 with SMTP id 24so2876049fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 23:50:44 -0700 (PDT)
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/7] p54usb: stop USB core interference in exit path
References: <200903052129.51790.chunkeey@web.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 14 Mar 2009 08:50:42 +0200
In-Reply-To: <200903052129.51790.chunkeey@web.de> (Christian Lamparter's message of "Thu\, 5 Mar 2009 21\:29\:51 +0100")
Message-ID: <8763ic4myl.fsf@litku.valot.fi> (sfid-20090314_075051_572555_1D81498F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@web.de> writes:

> The patch fixes a problem when the (Soft)LED stayed on after the module was unloaded.
> It turned out that the USB core disables all endpoints before calling the disconnect method.
> So it was impossible to switch off the radio & LEDs.

Please use shorter line length in the commit log.

-- 
Kalle Valo
