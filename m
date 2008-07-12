Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:56850 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbYGLWHk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2008 18:07:40 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KHnFf-0007r4-7b
	for linux-wireless@vger.kernel.org; Sat, 12 Jul 2008 22:07:35 +0000
Received: from 206-248-135-194.dsl.teksavvy.com ([206.248.135.194])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jul 2008 22:07:35 +0000
Received: from monnier by 206-248-135-194.dsl.teksavvy.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jul 2008 22:07:35 +0000
To: linux-wireless@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: Re: rt2x00 is still experimental?
Date: Sat, 12 Jul 2008 18:07:26 -0400
Message-ID: <jwvbq12g3va.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org> (sfid-20080713_000746_739409_1E40F1B9)
References: <1215811139.30975.10.camel@dv>
	<20080712104659.jsizw0ndw44cw4kc-cebfxv@webmail.spamcop.net>
	<200807121713.54123.IvDoorn@gmail.com>
	<200807121731.57208.mb@bu3sch.de>
	<69e28c910807120915h505640acp36efc67fd40a4953@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> to suggest people to use that alternative. EXPERIMENTAL should mean
> something that is not ready for the general public yet, not something
> that is simply under active development.

It seems that for several drivers the EXPERIMENTAL config flag would be
better replaced by an `experimental' module argument that enables the
in-development features.


        Stefan

