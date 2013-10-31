Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:41655 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab3JaUax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 16:30:53 -0400
Received: by mail-vc0-f171.google.com with SMTP id ik5so2378837vcb.30
        for <linux-wireless@vger.kernel.org>; Thu, 31 Oct 2013 13:30:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1383199449-18310-1-git-send-email-yeohchunyeow@gmail.com>
References: <1383199449-18310-1-git-send-email-yeohchunyeow@gmail.com>
Date: Thu, 31 Oct 2013 20:30:52 +0000
Message-ID: <CAFSJ42b4Og8LttAzTkzH924W=0yKqu35khvr4vB6bzLnbLHjcA@mail.gmail.com> (sfid-20131031_213059_346682_2B28D52E)
Subject: Re: [PATCH] wcn36xx: enable the beaconing in mesh mode
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	wcn36xx <wcn36xx@lists.infradead.org>,
	Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +               msg_body.tim_ie_offset = 256;

Does not look like correct value. Why 256?
