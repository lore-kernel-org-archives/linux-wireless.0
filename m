Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45929 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752063AbZC3N3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 09:29:16 -0400
Date: Mon, 30 Mar 2009 10:29:11 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
Subject: Re: [RFC] rfkill: rewrite
Message-ID: <20090330132911.GC11934@khazad-dum.debian.net> (sfid-20090330_152918_514838_A5623B1F)
References: <1238349195.24972.5.camel@johannes.local> <1238406057.24972.23.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238406057.24972.23.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 30 Mar 2009, Johannes Berg wrote:
>  * thinkpad_acpi.c
>    -> need help, convoluted code I don't understand at all, looks like
>       another candidate for rewriting

Heh.  I will take care of it, obviously.   As for rewriting, well, a cleanup
is in the queue.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
