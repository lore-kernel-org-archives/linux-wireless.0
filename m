Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53784
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762813AbYJJTIp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 15:08:45 -0400
Date: Fri, 10 Oct 2008 12:08:21 -0700 (PDT)
Message-Id: <20081010.120821.239091053.davem@davemloft.net> (sfid-20081010_210850_353291_B5A19A02)
To: lrodriguez@atheros.com
Cc: jirislaby@gmail.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	jmalinen@atheros.com
Subject: Re: [PATCH 1/1] Ath9k: fix uninitialized value in ath9k_hw_reset
From: David Miller <davem@davemloft.net>
In-Reply-To: <43e72e890810101207h767353bem3a080aab27b7eb09@mail.gmail.com>
References: <43e72e890810101200g3f50b204t20ea782878217369@mail.gmail.com>
	<20081010.120050.161276431.davem@davemloft.net>
	<43e72e890810101207h767353bem3a080aab27b7eb09@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 10 Oct 2008 12:07:47 -0700

> On Fri, Oct 10, 2008 at 12:00 PM, David Miller <davem@davemloft.net> wrote:
> > From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
> > Date: Fri, 10 Oct 2008 12:00:17 -0700
> >
> >> Agreed, patches welcomed.
> >
> > Translation: "Fix it yourself if you care so much." :-/
> 
> Not really, I want to fix it, just want to fix aggregation too.

Ok, as long as your intentions are clear :-)

> OK fine, I'll send a patch now.

Thank you.
