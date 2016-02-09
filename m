Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50221 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbcBIKvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2016 05:51:48 -0500
Date: Tue, 9 Feb 2016 13:51:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rt2x00: Fix queue related oops in case of deselected mac80211
 multi-queue feature.
Message-ID: <20160209105112.GO5273@mwanda> (sfid-20160209_115151_993201_C24858B1)
References: <20160208175559.GA13933@mwanda>
 <CAL1gcdOU7q1hgvVbfpzMroMxrMueaVHiAhyYz5A467+8e1oTbw@mail.gmail.com>
 <CAL1gcdOcXLq+A54xRy1fHYpwcBWMcGSoY77buWPPy+4j_ty3yA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL1gcdOcXLq+A54xRy1fHYpwcBWMcGSoY77buWPPy+4j_ty3yA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Ah.  Right I was expecting the order to be different, but the comment
does explain it.  Thanks for looking at this.

regards,
dan carpenter

