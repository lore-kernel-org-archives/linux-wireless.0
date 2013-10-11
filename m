Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038Ab3JKHYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 03:24:40 -0400
Message-ID: <1381476265.14293.0.camel@jlt4.sipsolutions.net> (sfid-20131011_092443_153943_77307F17)
Subject: Re: [wireless-next:master 82/98]
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h:88:24: sparse: incorrect type in
 assignment (different base types)
From: Johannes Berg <johannes@sipsolutions.net>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, kbuild-all@01.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx <wcn36xx@lists.infradead.org>
Date: Fri, 11 Oct 2013 09:24:25 +0200
In-Reply-To: <CAFSJ42aa_-DTHDxkRDM+0bm9052ree__K54CRm749SeQPDHwRw@mail.gmail.com> (sfid-20131011_091951_879185_187DCB17)
References: <525720d0.6xVLGLwuRrqxqOBI%fengguang.wu@intel.com>
	 <20131011014733.GD11191@localhost>
	 <CAFSJ42aa_-DTHDxkRDM+0bm9052ree__K54CRm749SeQPDHwRw@mail.gmail.com>
	 (sfid-20131011_091951_879185_187DCB17)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-10-11 at 08:19 +0100, Eugene Krasnikov wrote:
> Hm.. weird. I was sure that i fixed all sparse warnings before
> contribution. My sparse does not show this warning. Let me try to
> reproduce this error and come back to you. Thanx for you feedback.

> > reproduce: make C=1 CF=-D__CHECK_ENDIAN__



