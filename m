Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab1KRHoL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 02:44:11 -0500
Date: Fri, 18 Nov 2011 08:45:53 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Jonathan Nieder <jrnieder@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Greg Dietsche <Gregory.Dietsche@cuw.edu>,
	linux-kernel@vger.kernel.org
Subject: Re: iwl4965: "MAC is in deep sleep!" freezes
Message-ID: <20111118074552.GB2203@redhat.com> (sfid-20111118_084439_574130_893DC755)
References: <bbdbd01d4965ae789384bc1f9d0a2426@imap.dd24.net>
 <20110902233806.GA22157@elie>
 <20110905091918.GC2221@redhat.com>
 <265f56a4dc9f5d3edeca3d101e445353@imap.dd24.net>
 <20110908084913.GB2195@redhat.com>
 <1321228952.3362.15.camel@fermat.scientia.net>
 <20111114014615.GC16508@elie.hsd1.il.comcast.net>
 <1321466933.3364.16.camel@fermat.scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1321466933.3364.16.camel@fermat.scientia.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2011 at 07:08:53PM +0100, Christoph Anton Mitterer wrote:
> Which logs do you want,... then ones with the patch applied? Or without
Without patch

> and just from current 3.1?
Yes (I lose your old logs). But I also need verbose log for 2.6.38
(assuming 2.6.38 is the lates version where driver works for you)
to see what we do different regarding communication with firmware.
Capture good kernel log for about the same amout of time as bad
kernel log.

In summary: please provide logs as described previously here
http://article.gmane.org/gmane.linux.kernel/1187953
for 3.1 and 2.6.38.

Thanks
Stanislaw
