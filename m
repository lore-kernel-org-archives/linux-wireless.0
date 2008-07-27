Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from usul.saidi.cx ([204.11.33.34]:40826 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758522AbYG0WaD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 18:30:03 -0400
Message-ID: <488CF6D8.6000700@overt.org> (sfid-20080728_003009_177902_7480BA0C)
Date: Sun, 27 Jul 2008 15:29:44 -0700
From: Philip Langdale <philipl@overt.org>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	toshiba_acpi@memebeam.org,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
 through rfkill
References: <488CBBAB.6010508@overt.org> <200807272259.44364.IvDoorn@gmail.com>
In-Reply-To: <200807272259.44364.IvDoorn@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
> 
> You don't seem to be using rfkill_force_state() which is required to inform the rfkill
> layer about the state changes.

Hmm? According to rfkill.txt, one can either use force_state() or implement the
get_state() hook, and I have done the later. If this is not the correct method,
can you please explain when I should be using force_state?

--phil
