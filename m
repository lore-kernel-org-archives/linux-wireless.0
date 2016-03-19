Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:60806 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbcCSM1O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2016 08:27:14 -0400
Subject: Re: [PATCH DETAIL 13/19] rsi: Delete unnecessary variable
 initialisation
To: Julian Calaby <julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
 <c95f816da2d5c6789004e063e1b7adc44695718e.1458262312.git.julian.calaby@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <56ED4595.5050007@users.sourceforge.net> (sfid-20160319_132717_596196_68776E18)
Date: Sat, 19 Mar 2016 13:27:01 +0100
MIME-Version: 1.0
In-Reply-To: <c95f816da2d5c6789004e063e1b7adc44695718e.1458262312.git.julian.calaby@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> In rsi_send_data_pkt(), the following variables are assigned to
> before they're used:

Thanks for your interest in this update suggestion.
How do you think about to add the function name also to such
a mail subject so that the potential for confusion with an other
change can be eventually reduced around the source file "rsi_91x_pkt.c"?

Regards,
Markus
