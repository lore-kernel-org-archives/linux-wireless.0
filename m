Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:41555 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754217Ab1FHI0a (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:6:1>);
	Wed, 8 Jun 2011 04:26:30 -0400
Message-Id: <4DEFBED2020000230002DFA4@novprvlin0050.provo.novell.com> (sfid-20110608_102634_998603_EEAB6F94)
Date: Wed, 08 Jun 2011 02:26:26 -0600
From: "Joey Lee" <jlee@novell.com>
To: <marco@absence.it>
Cc: <dmitry.torokhov@gmail.com>, <malattia@linux.it>,
	<johannes@sipsolutions.net>, <mjg59@srcf.ucam.org>,
	<linux-wireless@vger.kernel.org>,
	<platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH 12/25] sony-laptop: input core improvements
 improvements
References: <4DE8FC4A.9010401@absence.it> <4DE9012E.5040207@absence.it>
 <20110604080717.GC7194@kamineko.org> <4DEA0C27.1000508@absence.it>
In-Reply-To: <4DEA0C27.1000508@absence.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

於 六，2011-06-04 於 12:42 +0200，Marco Chiappero 提到：
> Il 04/06/2011 10:07, Mattia Dongili ha scritto:
> > On Fri, Jun 03, 2011 at 05:43:42PM +0200, Marco Chiappero wrote:
> >> The code is now forwarding the SW_RFKILL_ALL event; added a couple
> >
> > I don't think we should do this.
> 
> As far as I know this event should be forwarded and the rfkill-input 
> code removed as soon as there is enough userspace support. Another 

There already have a urfkill daemon on userland has good support
killswitch:
http://www.freedesktop.org/wiki/Software/urfkill

But, 
rfkill-input will not removed:
http://www.spinics.net/lists/linux-acpi/msg32465.html

The above information for you reference.


Thank's a lot!
Joey Lee


