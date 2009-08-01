Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:43591 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbZHAWZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 18:25:38 -0400
Date: Sat, 1 Aug 2009 23:25:37 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-input@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL_ALL
Message-ID: <20090801222537.GA24262@srcf.ucam.org>
References: <1249152859-14769-1-git-send-email-mjg@redhat.com> <1249159133.3491.13.camel@localhost.localdomain> <20090801204534.GA23642@srcf.ucam.org> <1249159942.3491.21.camel@localhost.localdomain> <20090801205445.GA23751@srcf.ucam.org> <1249163327.3491.24.camel@localhost.localdomain> <20090801215130.GA24201@srcf.ucam.org> <1249164685.3491.28.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1249164685.3491.28.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 01, 2009 at 03:11:25PM -0700, Marcel Holtmann wrote:

> and that is what it should NOT imply. The policy if it applies to all
> internal devices, all devices in general or just WiFi or Bluetooth for
> example is up to the user.
> 
> We are NOT going to have any kind of RFKILL policy in the kernel in the
> future. We will remove rfkill-input once we have a proper userspace
> solution (aka rfkilld or similar).

We seem to be talking at cross purposes here. My objection to the name 
KEY_RFKILL is that it gives no indication what it's meant to be or why 
it's different to KEY_WLAN. KEY_RFKILL implies that it's the only input 
component that an rfkill policy agent needs to listen to, which isn't 
the case.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
