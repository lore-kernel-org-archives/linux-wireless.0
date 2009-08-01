Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:53289 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbZHAWL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 18:11:29 -0400
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL_ALL
From: Marcel Holtmann <marcel@holtmann.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-input@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, dmitry.torokhov@gmail.com
In-Reply-To: <20090801215130.GA24201@srcf.ucam.org>
References: <1249152859-14769-1-git-send-email-mjg@redhat.com>
	 <1249159133.3491.13.camel@localhost.localdomain>
	 <20090801204534.GA23642@srcf.ucam.org>
	 <1249159942.3491.21.camel@localhost.localdomain>
	 <20090801205445.GA23751@srcf.ucam.org>
	 <1249163327.3491.24.camel@localhost.localdomain>
	 <20090801215130.GA24201@srcf.ucam.org>
Content-Type: text/plain
Date: Sat, 01 Aug 2009 15:11:25 -0700
Message-Id: <1249164685.3491.28.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Matthew,

> > why is it confusing? I don't understanding your argument here. I think
> > the KEY_RFKILL_ALL is confusing is the user policy then only kills WiFi
> > devices or toggles between various on/off combinations.
> 
> Having it be KEY_RFKILL implies that KEY_WLAN and similar aren't related 
> to rfkill. KEY_RFKILL_ALL implies that the key invokes policy on all 
> rfkill devices, which is the aim here.

and that is what it should NOT imply. The policy if it applies to all
internal devices, all devices in general or just WiFi or Bluetooth for
example is up to the user.

We are NOT going to have any kind of RFKILL policy in the kernel in the
future. We will remove rfkill-input once we have a proper userspace
solution (aka rfkilld or similar).

Regards

Marcel


