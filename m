Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:46621 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751600AbZC3N1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 09:27:13 -0400
Date: Mon, 30 Mar 2009 10:27:09 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@opfer-online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
Subject: Re: [RFC] rfkill: rewrite
Message-ID: <20090330132709.GB11934@khazad-dum.debian.net> (sfid-20090330_152715_798337_51CC91B2)
References: <1238349195.24972.5.camel@johannes.local> <200903292016.05470.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200903292016.05470.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 29 Mar 2009, Ivo van Doorn wrote:
> Just for the record, as long as you (or somebody else) takes over maintainership
> over rfkill after these changes, I have no objections against the changes. Luckily
> you already updated the Maintainers entry, so I'm happy. :)
> 
> I know rfkill was poorly designed and I simply lacked the time (and perhaps
> some interest as well) to continue with it. The changes you propose sound
> reasonable so I hope it will turn rfkill really into something which it was supposed
> to be from the start.

Agreed.  I never wanted to do so much work on rfkill, either... I just
wanted something I could use in thinkpad-acpi, but that proved to be a lot
of work, as once you start, you want to finish it.

I will go over the new proposed rfkill to check if it is in a state that is
comfortable for drivers like thinkpad-acpi to use, and offer comments about
it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
