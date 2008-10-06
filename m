Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57045 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYJFSa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 14:30:58 -0400
Date: Mon, 6 Oct 2008 14:30:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, tim.dewaal@yahoo.com
Subject: Re: [RFC][PATCH 5/5] p54: integrate parts of lmac_longbow.h and
	stlc45xx
Message-ID: <20081006183013.GC3448@tuxdriver.com> (sfid-20081006_203101_353544_DAEAFC60)
References: <200810050239.44845.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200810050239.44845.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 05, 2008 at 02:39:44AM +0200, Christian Lamparter wrote:
> This patch removes most/all? of the "magic" numbers and unknown structure 
> variables inside the code and replaces them with meaningful prototypes.
> Therefore this patch got quite big.
> 
> However, I'm not really sure what "(C)" I should put in and where exactly.
> But I hope ST's/Nokia's Legal Department or someone else who understands the
> laws good enough can give us a green light.

Why wouldn't it be "Copyright (C) 2007 Conexant Systems, Inc." as
from lmac_longbow.h, if anything at all?  Or did you actually take
bits from stlc45xx?  Even then I'm not sure specific attribution is
necessary for a few structure/variable/function names.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
