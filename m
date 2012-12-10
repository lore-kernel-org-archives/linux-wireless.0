Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40099 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab2LJKVp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 05:21:45 -0500
Message-ID: <1355134918.9857.9.camel@jlt4.sipsolutions.net> (sfid-20121210_112446_737216_82298E55)
Subject: Re: [PATCH] wireless-regdb: add regulatory rule for ETSI members on
 60gHz band
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linville@tuxdriver.com, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 11:21:58 +0100
In-Reply-To: <1573921.0GjqNuABMd@lx-vladimir> (sfid-20121210_104554_770780_B8ABD895)
References: <8774585.BvFN3Opv12@lx-vladimir>
	 <1573921.0GjqNuABMd@lx-vladimir> (sfid-20121210_104554_770780_B8ABD895)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-12-10 at 11:45 +0200, Vladimir Kondratiev wrote:

> For the 60gHz band, regulation defined in the "Etsi En 302 567"
> http://docsfiles.com/pdf_final_draft_etsi_en_302_567.html

> +country AD:
> +        # 60 gHz band channels 1-4, ref: Etsi En 302 567
> +        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
> +        (57240 - 65880 @ 2160), (N/A, 25)

There doesn't seem to be a bandwidth limitation in the rules, should we
really put one into the database?

johannes

