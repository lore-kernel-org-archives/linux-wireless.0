Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:50929 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243AbZC1PWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 11:22:35 -0400
Date: Sat, 28 Mar 2009 15:22:26 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [RFC] rfkill/rfkill-input userspace API
Message-ID: <20090328152226.GA28425@srcf.ucam.org> (sfid-20090328_162239_149379_671D8133)
References: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br> <20090327221147.GA499@srcf.ucam.org> <20090328123645.GD7439@khazad-dum.debian.net> <20090328124719.GF7439@khazad-dum.debian.net> <20090328125301.GA26537@srcf.ucam.org> <20090328144823.GA6420@khazad-dum.debian.net> <20090328150202.GD27812@srcf.ucam.org> <20090328151416.GA8437@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090328151416.GA8437@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 28, 2009 at 12:14:16PM -0300, Henrique de Moraes Holschuh wrote:

> What version of the X server does this?  This kind of thing will
> probably need to end up in the rfkill-input docs :-(

1.5.3 or later, but any distribution running an earlier 1.5 should 
really cherry-pick it back - a lot gets broken otherwise. 
d936a4235c9625bd41569cef3452dd086284e0d7 is the commit. Pre-1.5 servers 
shouldn't be using evdev so won't have this problem.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
