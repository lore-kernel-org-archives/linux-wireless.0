Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43201 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab1DHMnZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 08:43:25 -0400
Received: by fxm17 with SMTP id 17so2301197fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 05:43:24 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: Questions about rt2800usb
Date: Fri, 8 Apr 2011 14:41:32 +0200
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	Steev Klimaszewski <steev@genesi-usa.com>,
	Jett Chen <jett_chen@ralinktech.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <888400.56093.qm@web161618.mail.bf1.yahoo.com>
In-Reply-To: <888400.56093.qm@web161618.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201104081441.32833.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 8. April 2011 schrieb Walter Goldens:
> Further investigation suggests the DUP! packets stem from one specific AP.
> Different APs seem to have less duplicate packets and overall packet-loss.
> Its puzzling to me however that the said AP does not produce DUP! packs
> at all with rt2870sta.

Is the AP 11n capable? Could you try to get a wifi capture when these
duplicates happen (with a second station in monitor mode)?

Thanks,
Helmut
