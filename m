Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:33684 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbYGVLWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 07:22:49 -0400
Date: Tue, 22 Jul 2008 08:22:45 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] RFKILL: set the status of the leds on activation.
Message-ID: <20080722112245.GC15136@khazad-dum.debian.net> (sfid-20080722_132252_190299_60F0C802)
References: <20080722102159.GA32682@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080722102159.GA32682@doriath.ww600.siemens.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 22 Jul 2008, Dmitry Baryshkov wrote:
> Provide default activate function to set the state of the led
> when the led becomes bound to the trigger

I think I understand what this is for, but I better ask to be sure...
What does it do, what is the use case?

>  This patch depends on the patch "leds: make sure led->trigger is set
>  earlier" which was staged in -mm for some time and recently got merged
>  into leds tree.

Will it get in mainline for 2.6.27-rc?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
