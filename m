Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:49689 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752828AbYIHD37 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2008 23:29:59 -0400
Date: Mon, 8 Sep 2008 00:29:53 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [RFC] acer-wmi: Add rfkill support for wireless and bluetooth
	(v3)
Message-ID: <20080908032953.GA26459@khazad-dum.debian.net> (sfid-20080908_053011_713961_C11FE30D)
References: <200808301206.56279.carlos@strangeworlds.co.uk> <200808301654.03329.carlos@strangeworlds.co.uk> <20080831133631.GA9794@khazad-dum.debian.net> <200809071813.23730.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809071813.23730.carlos@strangeworlds.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 07 Sep 2008, Carlos Corbacho wrote:
> +	status = get_u32(&state, ACER_CAP_WIRELESS);
> +	if (ACPI_SUCCESS(status))
> +		rfkill_force_state(wireless_rfkill, state);

Please fix all calls to rfkill_force_state(). Refer to my previous post on
this thread.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
