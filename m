Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out116.alice.it ([85.37.17.116]:2484 "EHLO
	smtp-out116.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab0EALx5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 07:53:57 -0400
Subject: Re: wl1251_sdio PSM
From: GNUtoo <GNUtoo@no-log.org>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <87sk6cjj20.fsf@purkki.valot.fi>
References: <1272230300.2349.23.camel@gnutoo-desktop>
	 <87sk6cjj20.fsf@purkki.valot.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 01 May 2010 13:53:49 +0200
Message-ID: <1272714829.2456.14.camel@gnutoo-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-05-01 at 08:19 +0300, Kalle Valo wrote:
> GNUtoo <GNUtoo@no-log.org> writes:
> 
> > Hi,
> 
> Hi Mr. GNUtoo,
> 
> > We are trying to make the htc dream(also known as G1) android phone
> > usable with a standard GNU(non android) userland.
> 
> I'm interested about this. Are there any references about this? For
> example, instructions how to install etc.
There is a status at
http://www.htc-linux.org/wiki/index.php?title=Dream#Status

Here are preview images with FSO:
http://downloads.freesmartphone.org/releases/fso2-preview-1/htcdream/

Zhone is only a test program,it's not our goal.
Our goal is targetting the SHR distribution instead
( http://trac.shr-project.org/trac )

For now In order to have a SHR image,for now you have to build one
yourself using openembedded
Select htcdream as the machine and shr as the distribution
also include that in the local.conf:
require conf/distro/include/fso-autorev.inc
require conf/distro/include/shr-autorev.inc

http://docs.openembedded.org/usermanual/usermanual.html#chapter_getting_oe
Contains some information on how to get the build system setup.

Denis.


