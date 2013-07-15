Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alpha.kreiz-it.fr ([178.32.219.166]:16454 "EHLO
	alpha.kreiz-it.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab3GOIVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 04:21:47 -0400
From: "Cedric GROSS" <cg@cgross.info>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: "'linux-wireless'" <linux-wireless@vger.kernel.org>,
	"'Adrian Chadd'" <adrian@freebsd.org>
References: "<001a01ce7fb1$75bfdc10$613f9430$@info>	<CA+icZUVoZkg3nT6=SwTaLCWoa+v6aLkXSP5b71a0GmxMMWOyHA@mail.gmail.com>	<001b01ce7fba$4bd15e20$e3741a60$@info>" <CA+icZUX9jvAcvEkKSsN-KU2GWxPVGg9Z=soecwJtPL0soHD4Zw@mail.gmail.com> <CANUX_P2K9_q_FnkzDrn4=Y3rzn3FvkPjCB4qGmts=7kni9oW4A@mail.gmail.com> <000301ce8077$252f1830$6f8d4890$@info> (sfid-20130714_114733_295326_9BBEA36B) <b04d657de9d7831febeff7b4ac8f371a@sipsolutions.net>
In-Reply-To: <b04d657de9d7831febeff7b4ac8f371a@sipsolutions.net>
Subject: RE: Firmware error for Centrino N 2230
Date: Mon, 15 Jul 2013 10:21:41 +0200
Message-ID: <001b01ce8134$5776a980$0663fc80$@info> (sfid-20130715_102150_853527_50BD8438)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

> De : Johannes Berg [mailto:johannes@sipsolutions.net]
> Envoyé : dimanche 14 juillet 2013 12:52
> À : Cedric GROSS; Adrian Chadd
> 
> > Many many many thanks. I will check that tomorrow.
> >
> > FreeBSD driver for intel wireless card is a bit old and need a lot of
> > improvement to manage new NIC.
> > Is there a way to get all assert code meaning ? It could be really a
> > big big help for me.
> 
> Unfortunately not, but have you seen the "iwl" FreeBSD driver that we
> posted a while ago? That should help you some. Are you in contact with
> anyone else maybe?

I get this version of iwl : https://github.com/seanbruno/freebsd-iwl
But this one also doesn't work with my card. I also trying to modify for my NIC. For the moment I had a failure at the first RXON command.

I'm in contact only with Hiren Panchasara (hiren@freebsd.org).
I wrote to ilw at linux.intel.com also but no answer for the moment.

> 
> johannes

