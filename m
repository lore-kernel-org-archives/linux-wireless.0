Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55606 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbXLGTem (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 14:34:42 -0500
Subject: Re: [PATCH] libertas: implement new scanning logic
From: David Woodhouse <dwmw2@infradead.org>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <1197054852.4465.7.camel@localhost.localdomain>
References: <200711290927.15915.hs4233@mail.mn-solutions.de>
	 <1196787130.4772.2.camel@localhost.localdomain>
	 <200712071547.37944.hs4233@mail.mn-solutions.de>
	 <1197050263.30465.7.camel@localhost.localdomain>
	 <1197050743.13978.606.camel@pmac.infradead.org>
	 <1197050996.30465.17.camel@localhost.localdomain>
	 <1197051573.13978.612.camel@pmac.infradead.org>
	 <1197051857.30465.30.camel@localhost.localdomain>
	 <1197052412.13978.620.camel@pmac.infradead.org>
	 <1197054852.4465.7.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 19:34:38 +0000
Message-Id: <1197056078.13978.629.camel@pmac.infradead.org> (sfid-20071207_193445_776997_93C81251)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 2007-12-07 at 14:14 -0500, Dan Williams wrote:
> You could, but there's not too much of a point in spending time on
> this unless you've got a really good reason?  I'm sure there are more
> important things to do in the driver...

Indeed. That's exactly the reason I left it returning IW_ENCODE_NOKEY
for WPA, although my patch fixes it for WEP.

-- 
dwmw2

