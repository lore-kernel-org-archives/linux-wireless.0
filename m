Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45481 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab0IVNpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 09:45:51 -0400
Received: by fxm3 with SMTP id 3so277220fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 06:45:49 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Manual Control about Sending ACKs
Date: Wed, 22 Sep 2010 15:45:40 +0200
Cc: Daniel Berger <daniel@dat-berger.de>,
	linux-wireless@vger.kernel.org
References: <20100922123953.67a4fc5e@danmob> <20100922130245.GC5515@tuxdriver.com>
In-Reply-To: <20100922130245.GC5515@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009221545.41377.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 22 September 2010 15:02:45 John W. Linville wrote:
> On Wed, Sep 22, 2010 at 12:39:53PM +0200, Daniel Berger wrote:
> 
> > Thus I deduce ACK sending is completely done in hardware.
> 
> Yes, I believe this is the case with all of our supported hardware.
> 
> > Is my conclusion and understanding right? Is there any possible solution
> > to my problem of sending ACKs manually? Would that be fast enough for
> > the SIFS and other stations' ACK timeout?
> 
> I suspect you need to be looking at hacking firmware.
> You might look at the open-source ar9170 firmware
> or the b43-openfwwf project.

probably not ar9170 either.
The ACK - mechanism (response control) is mostly hardwired in
the chip, there is not much to control here.
