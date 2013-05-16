Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:55481 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab3EPPel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 11:34:41 -0400
Received: by mail-we0-f180.google.com with SMTP id n5so2673102wev.25
        for <linux-wireless@vger.kernel.org>; Thu, 16 May 2013 08:34:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130516114028.GA27887@pandem0nium>
References: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<CAJ-VmonrfSx6KLjNdPwtV_8q=Jmjz9KRSYmoLSXt7yocU=y35A@mail.gmail.com>
	<20130516114028.GA27887@pandem0nium>
Date: Thu, 16 May 2013 08:34:39 -0700
Message-ID: <CAJ-Vmo=39cS38UCDeQrdJ7x-t=cyr8cnsf3G2opxyeY3KzWLUg@mail.gmail.com> (sfid-20130516_173444_581087_E2523748)
Subject: Re: [PATCHv2 00/18] Add support for 5 and 10 MHz channels
From: Adrian Chadd <adrian@freebsd.org>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

How about I setup a couple of FreeBSD devices with 5/10MHz operating
modes and dump the beacon IEs, probe request/response and assoc
request/response?

That way you can see what the rate table entries look like.

Thanks!


Adrian
