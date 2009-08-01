Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:38435 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbZHAVvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 17:51:32 -0400
Date: Sat, 1 Aug 2009 22:51:30 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-input@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL_ALL
Message-ID: <20090801215130.GA24201@srcf.ucam.org>
References: <1249152859-14769-1-git-send-email-mjg@redhat.com> <1249159133.3491.13.camel@localhost.localdomain> <20090801204534.GA23642@srcf.ucam.org> <1249159942.3491.21.camel@localhost.localdomain> <20090801205445.GA23751@srcf.ucam.org> <1249163327.3491.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1249163327.3491.24.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 01, 2009 at 02:48:47PM -0700, Marcel Holtmann wrote:

> why is it confusing? I don't understanding your argument here. I think
> the KEY_RFKILL_ALL is confusing is the user policy then only kills WiFi
> devices or toggles between various on/off combinations.

Having it be KEY_RFKILL implies that KEY_WLAN and similar aren't related 
to rfkill. KEY_RFKILL_ALL implies that the key invokes policy on all 
rfkill devices, which is the aim here.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
