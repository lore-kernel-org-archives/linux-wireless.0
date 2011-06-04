Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aa012-1msr.fastwebnet.it ([62.101.93.132]:44664 "EHLO
	aa012-1msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab1FDNLa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2011 09:11:30 -0400
Message-ID: <4DEA2EFF.9040206@absence.it> (sfid-20110604_151138_151984_20F35D29)
Date: Sat, 04 Jun 2011 15:11:27 +0200
From: Marco Chiappero <marco@absence.it>
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Mattia Dongili <malattia@linux.it>,
	platform-driver-x86@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 12/25] sony-laptop: input core improvements improvements
References: <4DE8FC4A.9010401@absence.it> <4DE9012E.5040207@absence.it> <20110604080717.GC7194@kamineko.org> <4DEA0C27.1000508@absence.it> <20110604124448.GB14809@srcf.ucam.org>
In-Reply-To: <20110604124448.GB14809@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Il 04/06/2011 14:44, Matthew Garrett ha scritto:
> This event should be sent if hitting the switch is a request to
> userspace. If pressing it causes the hardware to perform the change and
> this is merely a notification that the change has been made, it
> shouldn't be sent.

Ok, I didn't know about this difference, I'll remove it and update the 
patch.

