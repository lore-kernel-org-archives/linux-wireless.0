Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:40911 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbYGVN5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 09:57:08 -0400
Received: by an-out-0708.google.com with SMTP id d40so443417and.103
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2008 06:57:07 -0700 (PDT)
Date: Tue, 22 Jul 2008 09:57:02 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 5/6] rfkill: query EV_SW states when rfkill-input
	(re)?connects to a input device
Message-ID: <20080722095600.ZZRA012@mailhub.coreip.homeip.net> (sfid-20080722_155714_034028_5FD93D64)
References: <1216685902-9373-1-git-send-email-hmh@hmh.eng.br> <1216685902-9373-6-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1216685902-9373-6-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 21, 2008 at 09:18:21PM -0300, Henrique de Moraes Holschuh wrote:
> Every time a new input device that is capable of one of the rfkill EV_SW events
> (currently only SW_RFKILL_ALL) is connected to rfkill-input, we must check the
> states of the input EV_SW switches and take action.  Otherwise, we will ignore
> the initial switch state.
> 
> We also need to re-check the states of the EV_SW switches after a device that
> was under an exclusive grab is released back to us, since we got no input
> events from that device while it was grabbed.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>

Looks good, you may add:

Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry
