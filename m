Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out12.libero.it ([212.52.84.112]:48115 "EHLO
	cp-out12.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab0FDIZN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 04:25:13 -0400
From: Fabio Rossi <rossi.f@inwind.it>
To: linux-wireless@vger.kernel.org
Subject: Re: WARNING: at drivers/base/core.c:130 device_release+0x82/0x90()
Date: Fri, 4 Jun 2010 10:25:08 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
References: <201006021129.43621.rossi.f@inwind.it> <AANLkTik0A8qhlIi1pjvo0DKXhxjBEYEwOCn6iIsLXFJi@mail.gmail.com>
In-Reply-To: <AANLkTik0A8qhlIi1pjvo0DKXhxjBEYEwOCn6iIsLXFJi@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201006041025.08348.rossi.f@inwind.it>
Content-Type: Text/Plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 02 June 2010 23:42:14 Luis R. Rodriguez wrote:

> On Wed, Jun 2, 2010 at 2:29 AM, Fabio Rossi <rossi.f@inwind.it> wrote:
> > Compiling the kernel without ACPI (CONFIG_ACPI=n) gives the following
> > warning:
> > 
> > cfg80211: Calling CRDA to update world regulatory domain
> > cfg80211: World regulatory domain updated:
> >    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> >    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> > ath5k 0000:08:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> > ath5k 0000:08:01.0: registered as 'phy0'
> > ath5k phy0: request_irq failed
> > ------------[ cut here ]------------
> 
> Since traces are printed reversed you will have to read my logic from
> bottom to top:
> 
> Seems we need to implement the dev_release() op for the class of our
> devices.

Shall I open a bug in kernel bugzilla to keep trace of this?

Fabio
