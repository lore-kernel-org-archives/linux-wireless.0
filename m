Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:44474 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZHBBPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 21:15:47 -0400
Date: Sun, 2 Aug 2009 02:15:45 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-input@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL_ALL
Message-ID: <20090802011545.GA25618@srcf.ucam.org>
References: <1249152859-14769-1-git-send-email-mjg@redhat.com> <20090802010557.GA11073@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090802010557.GA11073@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 01, 2009 at 10:05:57PM -0300, Henrique de Moraes Holschuh wrote:
> On Sat, 01 Aug 2009, Matthew Garrett wrote:
> > This patch adds a new keycode, KEY_RFKILL_ALL. It indicates that the
> > system should toggle the state of all rfkillable devices.
> 
> What should happen when you press it?  Toggle state, or the same as EV_SW
> SW_RFKILL_ALL OFF (i.e. radios off, killing active) ?

rfkill-input should toggle, userspace policy can be anything.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
