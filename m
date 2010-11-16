Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44998 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab0KPXPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 18:15:17 -0500
Subject: Re: RFC/PATCH:  Allow wpa_supplicant to share scan results.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CE30B17.6090109@candelatech.com>
References: <4CE1CEC6.2050103@candelatech.com>
	 <20101116094512.GB21872@jm.kir.nu> <4CE2B953.9090509@candelatech.com>
	 <20101116193156.GA32723@jm.kir.nu> <4CE2E215.1090906@candelatech.com>
	 <20101116223658.GA5310@jm.kir.nu>  <4CE30B17.6090109@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 15:16:45 -0800
Message-ID: <1289949405.3673.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-16 at 14:52 -0800, Ben Greear wrote:

> Well, this is all good for supplicant, but same problem exists for
> un-encrypted interfaces that use the built-in kernel scanning.  However,
> I can carry my own patch if needed..it's still useful to get this
> working with supplicant.

You do know, of course, that you should be running the supplicant anyway
even then, for various "simple" reasons like roaming etc.

johannes

