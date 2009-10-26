Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out12.libero.it ([212.52.84.112]:49652 "EHLO
	cp-out12.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbZJZVAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 17:00:35 -0400
From: Fabio Rossi <rossi.f@inwind.it>
To: linux-wireless@vger.kernel.org
Subject: Re: ath5k: no further txbuf available, dropping packet
Date: Mon, 26 Oct 2009 21:57:36 +0100
Cc: Michael Buesch <mb@bu3sch.de>, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>
References: <200910231608.18676.mb@bu3sch.de>
In-Reply-To: <200910231608.18676.mb@bu3sch.de>
MIME-Version: 1.0
Message-Id: <200910262157.36141.rossi.f@inwind.it>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 October 2009 16:08:16 Michael Buesch wrote:

> ath5k breaks in AP mode after some operation time and keeps throwing
> this message:
> 
> [2096249.446071] ath5k phy0: no further txbuf available, dropping packet
> 
> Driver is yesterday's compat-wireless on 2.6.31.1

I got the same message but in managed mode with the latest git wireless 
testing (v2.6.32-rc5-40584-g9b469da)
