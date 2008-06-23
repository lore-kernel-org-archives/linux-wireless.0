Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:40754 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYFWCYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 22:24:18 -0400
Received: by an-out-0708.google.com with SMTP id d40so539607and.103
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jun 2008 19:24:17 -0700 (PDT)
Date: Sun, 22 Jun 2008 22:24:12 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Dan Williams <dcbw@redhat.com>,
	Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 12/12] rfkill: document rw rfkill switches and clarify
	input subsystem interactions
Message-ID: <20080623022412.GC24992@anvil.corenet.prv> (sfid-20080623_042422_635854_B606332B)
References: <1214149128-5913-1-git-send-email-hmh@hmh.eng.br> <1214149128-5913-13-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1214149128-5913-13-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henrique,

On Sun, Jun 22, 2008 at 12:38:48PM -0300, Henrique de Moraes Holschuh wrote:
> +2: Implementation details
> +
> +The rfkill class provides kernel drivers with an interface that allows them to
> +know when they should enable or disable a wireless network device transmitter.
> +
> +The rfkill-input module provides the kernel with the ability to implement
> +a basic response when the user presses a key or button (or toggles a switch)
> +related to rfkill functionality.  This is optional, and can also be done in
> +userspace.
> +
> +The rfkill-input module also provides EPO (emergency power-off) functionality
> +for all wireless transmitters.  This function cannot be overriden, and it is
> +always active.  rfkill EPO is related to *_RFKILL_ALL input events.
> +

I think I would like to see the statement that rfkill-input is an
in-kernel implementation of default policy of reacting to Wifi-related
(in wide sense) button presses and neither mandatory nor required for
wireless drivers to operate.

-- 
Dmitry
