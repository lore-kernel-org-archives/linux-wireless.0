Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42991 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbcFWLfp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 07:35:45 -0400
Message-ID: <1466681739.11061.3.camel@sipsolutions.net> (sfid-20160623_133620_451943_39C29DC6)
Subject: Re: [PATCH] wlcore: time sync : add support for 64 bit clock
From: Johannes Berg <johannes@sipsolutions.net>
To: "Machani, Yaniv" <yanivma@ti.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>, "Mishol, Guy" <guym@ti.com>,
	Eliad Peller <eliad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Thu, 23 Jun 2016 13:35:39 +0200
In-Reply-To: <AE1C82FB3D0EC64DB1F752C81CBD1101391CF584@DFRE01.ent.ti.com>
References: <20160623111332.23326-1-yanivma@ti.com>
	 (sfid-20160623_131215_419855_E4550AFE)
 <1466680680.11061.2.camel@sipsolutions.net>
	 <AE1C82FB3D0EC64DB1F752C81CBD1101391CF584@DFRE01.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > Additionally, this looks like it changes the firmware API, so that 
> > older firmware images will no longer work?
> 
> It is backwards compatible, 
> although it changes a API structure, older firmware are using only
> u16 for the field so there is no impact on that.
> 

Oh, ok. I had also thought that the size changed, but missed that you
replaced a u32 with two u16. Thanks for checking :)

johannes
