Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:39559 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758023AbZGGQdU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 12:33:20 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] p54: fix beacon template dtim IE corruption
Date: Tue, 7 Jul 2009 20:33:10 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <200907041824.07655.chunkeey@web.de> <20090707160431.GB2768@tuxdriver.com>
In-Reply-To: <20090707160431.GB2768@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907072033.10183.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 07 July 2009 18:04:32 John W. Linville wrote:
> On Sat, Jul 04, 2009 at 06:24:07PM +0200, Christian Lamparter wrote:
> > This patch fixes a regression that sneaked in with 
> > "[PATCH] p54: re-enable power save feature".
> > When p54_beacon_format_ie_tim was divided up
> > and rewritten to use skb_* macros.
> 
> I don't seem to have any record of that patch,
hmm, it's right here...
http://www.spinics.net/lists/linux-wireless/msg35201.html

maybe it was lost during the holiday, should I prepare a resend?

Regards,
	Chr
