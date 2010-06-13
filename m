Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56913 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab0FMVCn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jun 2010 17:02:43 -0400
MIME-Version: 1.0
In-Reply-To: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 13 Jun 2010 14:02:23 -0700
Message-ID: <AANLkTimKVhaBtHujNjbiOxsgj80WF4sar2RCe-AkIU9j@mail.gmail.com>
Subject: Re: 2.6.35-rc3: Reported regressions 2.6.33 -> 2.6.34
To: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Aeolus Yang <Aeolus.Yang@atheros.com>,
	David Quan <David.Quan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For your convenience in reading the regression report here's the
802.11 and Bluetooth ones. There's one PCMCIA one which I left in as I
think these patches now go through John (?) The other ones are 1
Bluetooth regression, 1 hostap_pci, 1 iwl3945 and 1 iwlagn regression.

  Luis

On Sun, Jun 13, 2010 at 7:45 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Unresolved regressions
> ----------------------

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16111
> Subject         : hostap_pci: infinite registered netdevice wifi0
> Submitter       : Petr Pisar <petr.pisar@atlas.cz>
> Date            : 2010-06-02 20:55 (12 days old)

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16084
> Subject         : iwl3945 bug in 2.6.34
> Submitter       : Satish Eerpini <eerpini@gmail.com>
> Date            : 2010-05-23 6:37 (22 days old)
> Message-ID      : <AANLkTik_7rxDBc0TKlAfoYyM5S6Cf_Hyxbr4W5ORnTsq@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=127459596015626&w=2

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15862
> Subject         : 2.6.34-rc4/5: iwlagn unusable until reload
> Submitter       : Nico Schottelius <nico-linux-20100427@schottelius.org>
> Date            : 2010-04-27 7:49 (48 days old)
> Message-ID      : <20100427074934.GB3261@ikn.schottelius.org>
> References      : http://marc.info/?l=linux-kernel&m=127235784004839&w=2

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15717
> Subject         : bluetooth oops
> Submitter       : Pavel Machek <pavel@ucw.cz>
> Date            : 2010-03-14 20:14 (92 days old)
> Message-ID      : <20100314201434.GE22059@elf.ucw.cz>
> References      : http://marc.info/?l=linux-kernel&m=126859771528426&w=4
> Handled-By      : Marcel Holtmann <marcel@holtmann.org>

> Regressions with patches
> ------------------------

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16138
> Subject         : PCMCIA regression
> Submitter       : Mikulas Patocka <mpatocka@redhat.com>
> Date            : 2010-05-25 20:25 (20 days old)
> Message-ID      : <Pine.LNX.4.64.1005251619020.12278@hs20-bc2-1.build.redhat.com>
> References      : http://marc.info/?l=linux-kernel&m=127481913909672&w=2
> Handled-By      : Dominik Brodowski <linux@brodo.de>
> Patch           : https://bugzilla.kernel.org/attachment.cgi?id=26685
