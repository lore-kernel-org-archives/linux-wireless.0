Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:10367 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbYDAMmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 08:42:53 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [RFC] libertas: convert libertas driver to use an event/cmdresp queue
Date: Tue, 1 Apr 2008 14:39:54 +0200
Cc: linux-wireless@vger.kernel.org
References: <200803271700.58477.hs4233@mail.mn-solutions.de> <1206722403.3392.9.camel@localhost.localdomain>
In-Reply-To: <1206722403.3392.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804011439.54618.hs4233@mail.mn-solutions.de> (sfid-20080401_134256_604421_C7F9CDC1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It's been tested lightly on USB, SDIO, and CF.  I'd like wider
> testing on CF as this patch causes SSH transfers to stall
> (only on CF!)

I've modified if_cs.c somewhat and did

$ scp inkscape inkview emacs-snapshot-x mtn \
  emacs-snapshot-nox pgadmin3 quanta gs-gpl \
  root@10.2.1.4:/tmp
inkscape           100% 5856KB 650.7KB/s   00:09
inkview            100% 5853KB 585.3KB/s   00:10
emacs-snapshot-x   100% 5333KB 666.6KB/s   00:08
mtn                100% 5263KB 657.9KB/s   00:08
emacs-snapshot-nox 100% 4913KB 614.1KB/s   00:08
pgadmin3           100% 3925KB 654.2KB/s   00:06
quanta             100% 3597KB 719.5KB/s   00:05
gs-gpl             100% 3597KB 599.4KB/s   00:06

I didn't notice any stall so far.  What test did you make?
