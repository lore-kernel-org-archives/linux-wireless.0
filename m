Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aa013-1msr.fastwebnet.it ([62.101.93.133]:47990 "EHLO
	aa013-1msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab1FDKui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2011 06:50:38 -0400
Message-ID: <4DEA0C27.1000508@absence.it> (sfid-20110604_125041_031349_7F976658)
Date: Sat, 04 Jun 2011 12:42:47 +0200
From: Marco Chiappero <marco@absence.it>
MIME-Version: 1.0
To: Mattia Dongili <malattia@linux.it>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
	platform-driver-x86@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 12/25] sony-laptop: input core improvements improvements
References: <4DE8FC4A.9010401@absence.it> <4DE9012E.5040207@absence.it> <20110604080717.GC7194@kamineko.org>
In-Reply-To: <20110604080717.GC7194@kamineko.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Il 04/06/2011 10:07, Mattia Dongili ha scritto:
> On Fri, Jun 03, 2011 at 05:43:42PM +0200, Marco Chiappero wrote:
>> The code is now forwarding the SW_RFKILL_ALL event; added a couple
>
> I don't think we should do this.

As far as I know this event should be forwarded and the rfkill-input 
code removed as soon as there is enough userspace support. Another 
platform driver (thinkpad_acpi) is using it.
What is right and what is wrong? Should it be removed from thinkpad_acpi 
too?
