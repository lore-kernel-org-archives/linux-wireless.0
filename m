Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33312 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbcDUSvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2016 14:51:42 -0400
Received: by mail-oi0-f51.google.com with SMTP id r78so96671092oie.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2016 11:51:42 -0700 (PDT)
Date: Thu, 21 Apr 2016 13:51:34 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Maximilian Engelhardt <engelhardt@perisens.de>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	maxi@daemonizer.de
Subject: Re: wireless-regdb: Update regulatory rules for Germany (DE) on 5GHz
Message-ID: <20160421185134.GD95003@ubuntu-hedt> (sfid-20160421_205146_638393_0DC39696)
References: <1958820.LBuzOElZFT@perisens15>
 <20160421131938.GA95003@ubuntu-hedt>
 <2919568.ssjlN6KUVX@perisens15>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <2919568.ssjlN6KUVX@perisens15>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 21, 2016 at 08:08:46PM +0200, Maximilian Engelhardt wrote:
> On Thursday 21 April 2016 08:19:38 Seth Forshee wrote:
> > On Tue, Apr 19, 2016 at 08:03:16PM +0200, Maximilian Engelhardt wrote:
> > > Hi,
> > > 
> > > In Europe ETSI standardized the used for short range devices (SRD) [1] in
> > > ETSI EN 300 440-1 [2].
> > > According to this standard generic use equipment is allowed to transmit in
> > > the frequency range form 5725 MHz to 5875 MHz with a maximum output power
> > > of 25 mW e.i.r.p. This generic allocation also allows transmission of
> > > 802.11 devices.
> > > 
> > > [3] has a list of countries and their status about the implementation of
> > > the SRD frequency bands. For the 5 GHz band this can be seen on page 38
> > > in the paragraph ANNEX 1 and the entry Annex j.
> > > 
> > > Attached is a patch that adds the 5 GHz SRD band to db.txt for Germany.
> > > 
> > > If it is acceptable I can provide a patch adding the 5 GHz SRD band for
> > > the
> > > other countries listed in [3].
> > 
> > The changes seem okay as far as I can tell. You do need to include your
> > signed-off-by tag on the patch however, see
> > https://git.kernel.org/cgit/linux/kernel/git/sforshee/wireless-regdb.git/tre
> > e/CONTRIBUTING.
> > 
> > Thanks,
> > Seth
> 
> Hi Seth,
> 
> Thanks for your reply. You can find my signed-off-by tag below together with 
> the unchanged patch.

Thanks, that will work. I'll leave it for a few days and see if anyone
else has comments.

> I can affirm I did check this carefully with the official documents of the 
> German administration for radio equipment (Bundesnetzagentur für Elektrizität, 
> Gas, Telekommunikation, Post und Eisenbahnen).
> 
> I noticed that the links to the other entries for Germany are broken, as the 
> website design was changed and thus all old link became non functional. I can 
> provide a patch fixing this if it is something that's considered useful.

Yes, that would be useful, so please do.

> The comments to my initial mail indicated that the statement in the ERC 
> recommendation I linked are alone not enough to add this frequency ranges for 
> other countries. Unfortunately I don't have the possibility to do these checks 
> for countries other than Germany.

Yep, I understand and am in agreement. I know how challenging it can be
to try to track down this information.

Thanks,
Seth
