Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from usul.saidi.cx ([204.11.33.34]:54618 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751423AbYG1OSB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 10:18:01 -0400
Message-ID: <488DD500.1050805@overt.org> (sfid-20080728_161806_436599_0047DB29)
Date: Mon, 28 Jul 2008 07:17:36 -0700
From: Philip Langdale <philipl@overt.org>
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Ivo van Doorn <ivdoorn@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	toshiba_acpi@memebeam.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
 through rfkill
References: <488CBBAB.6010508@overt.org> <200807272259.44364.IvDoorn@gmail.com> <488CF6D8.6000700@overt.org> <20080728030437.GC10672@khazad-dum.debian.net>
In-Reply-To: <20080728030437.GC10672@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
> 
> There is a bunch of rfkill bug fix patches that was not merged in
> wireless-testing yet (which is a pity, it would be really good if they could
> go into 2.6.27).  One of those patches fixes the docs to make it clear that
> rfkill_force_state() is the way to go if you have events of any sort.
> 
> The big difference from get_state() is that rfkill_force_state() propagates
> state changes as soon as your driver notices them and sends them to rfkill
> through rfkill_force_state()... while get_state() can only do that when
> someone asks rfkill about the current state.

Fair enough. I'll update the patch when I get some time. And good point on how
to react to the event; dunno what I was(n't) thinking. :-)

--phil
