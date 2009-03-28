Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:43482 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbZC1MxG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 08:53:06 -0400
Date: Sat, 28 Mar 2009 12:53:01 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [RFC] rfkill/rfkill-input userspace API
Message-ID: <20090328125301.GA26537@srcf.ucam.org> (sfid-20090328_135313_459747_B4686F68)
References: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br> <20090327221147.GA499@srcf.ucam.org> <20090328123645.GD7439@khazad-dum.debian.net> <20090328124719.GF7439@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090328124719.GF7439@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 28, 2009 at 09:47:19AM -0300, Henrique de Moraes Holschuh wrote:
> Hi Matthew!
> > Eh? What is that ioctl in the git version doing there, then?  Did I
> > get the code from the wrong branch or something?
> 
> Ok, more on this: the ioctl _is_ needed for privacy reasons, it wasn't
> added there just for the kick of it AFAIK.  Instead of just breaking
> things the other way, can we configure evdev to sometimes do the grab,
> and sometimes not, depending on a config option for that particular
> device? 

No it's not. The event devices are only readable by root, and root can 
get your keypresses anyway.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
