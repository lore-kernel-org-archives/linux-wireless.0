Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65400 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758283Ab2CUUQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 16:16:44 -0400
Received: by dajr28 with SMTP id r28so2043176daj.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Mar 2012 13:16:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120321175800.GA28516@aldebaran.gro-tsen.net>
References: <20120321175800.GA28516@aldebaran.gro-tsen.net>
Date: Wed, 21 Mar 2012 13:16:44 -0700
Message-ID: <CAJ-Vmom2fPUuuT8mUa2fWrbBQGuDtd7nh7Tkn3Sa2_TmhjtJaA@mail.gmail.com> (sfid-20120321_211648_248969_23EAACE4)
Subject: Re: ath9k_htc fails with "Target is unresponsive"
From: Adrian Chadd <adrian@freebsd.org>
To: David Madore <david+ml@madore.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi
,
Are you sure this isn't partially a USB controller/initialisation problem?

What's the exact combination that works/fails?

* power on boot with the dongle plugged in;
* reset pins shorted with the dongle plugged in;
* "reboot" from a running system with the dongle plugged in;

.. then repeat the above with the dongle unplugged during system
POST/boot, then plug it in once everything has initialised to
multi-user mode?



Adrian
