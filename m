Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:41591 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbZDYWJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 18:09:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rc3-git1: Reported regressions from 2.6.29
Cc: Adrian Bunk <bunk@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Natalie Protasevich <protasnb@gmail.com>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	Linux ACPI <linux-acpi@vger.kernel.org>,
	Linux PM List <linux-pm@lists.linux-foundation.org>,
	Linux SCSI List <linux-scsi@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <47KgT3nlbjD.A.lnB.jc48JB@chimera> (sfid-20090426_000942_091696_56EF06C7)
Date: Sat, 25 Apr 2009 21:22:37 +0200 (CEST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[NOTE:
 The list of regressions from 2.6.28 (introduced up to 2.6.29) will be =
sent
 tomorrow (there still are quite a few of them listed).]

This message contains a list of some regressions from 2.6.29, for which=
 there
are no fixes in the mainline I know of.  If any of them have been fixed=
 already,
please let me know.

If you know of any other unresolved regressions from 2.6.29, please let=
 me know
either and I'll add them to the list.  Also, please let me know if any =
of the
entries below are invalid.

Each entry from the list will be sent additionally in an automatic repl=
y to
this message with CCs to the people involved in reporting and handling =
the
issue.


Listed regressions statistics:

  Date          Total  Pending  Unresolved
  ----------------------------------------
  2009-04-25       55       36          26
  2009-04-17       37       35          28


Unresolved regressions
----------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13188
Subject		: horizontal strips of the screen frozen
Submitter	: Justin Madru <jdm64@gawab.com>
Date		: 2009-04-24 20:59 (2 days old)
=46irst-Bad-Commit: http://git.kernel.org/?p=3Dlinux/kernel/git/torvald=
s/linux-2.6.git;a=3Dcommit;h=3D280b713b5b0fd84cf2469098aee88acbb5de859c
References	: http://marc.info/?l=3Dlinux-kernel&m=3D124060685315937&w=3D=
4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13187
Subject		: garbled screen on video
Submitter	: Justin Madru <jdm64@gawab.com>
Date		: 2009-04-24 0:52 (2 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D124053437914036&w=3D=
4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13181
Subject		: Crash in v2.6.30-rc3 (regression from 30-rc2)
Submitter	: Gregory Haskins <ghaskins@novell.com>
Date		: 2009-04-23 2:29 (3 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D124045383628477&w=3D=
4
		  http://marc.info/?l=3Dlinux-kernel&m=3D124033993702882&w=3D4
Handled-By	: Jens Axboe <jens.axboe@oracle.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13180
Subject		: 2.6.30-rc2: WARNING at i915_gem.c for i915_gem_idle
Submitter	: Niel Lambrechts <niel.lambrechts@gmail.com>
Date		: 2009-04-21 21:35 (5 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D124034980819102&w=3D=
4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13179
Subject		: CD-R: wodim intermittent failures
Submitter	: Andy Isaacson <adi@hexapodia.org>
Date		: 2009-04-21 1:52 (5 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D124027879214231&w=3D=
4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13177
Subject		: 2.6.30-rc2-git7 build problem
Submitter	: Martin Knoblauch <spamtrap@knobisoft.de>
Date		: 2009-04-21 13:39 (5 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D124032163602132&w=3D=
4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13171
Subject		: 2.6.30-rc2 + xorg-intel-2.7.0 + DRM_I915_KMS =3D corruption
Submitter	: Alex Bennee <kernel-hacker@bennee.com>
Date		: 2009-04-19 6:27 (7 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D124022460014812&w=3D=
4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13168
Subject		: ath5k fails to associate with AP
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2009-04-25 14:04 (1 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13164
Subject		: 2.6.30-rc2 soft lockups: ACPI?  clock source problem?
Submitter	: Dave Hansen <dave@sr71.net>
Date		: 2009-04-21 17:30 (5 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D124033550127455&w=3D=
4
Handled-By	: john stultz <johnstul@us.ibm.com>
		  Len Brown <lenb@kernel.org>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13156
Subject		: keyboard backlight brightness up/down keys doesn't work
Submitter	: Thomas Meyer <thomas@m3y3r.de>
Date		: 2009-04-23 20:46 (3 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13154
Subject		: iwlagn soft lock-up
Submitter	: Panagiotis Papadakos <papadako@csd.uoc.gr>
Date		: 2009-04-22 22:12 (4 days old)


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13151
Subject		: Warning about reiserfs
Submitter	: D=C3=A2niel Fraga <fragabr@gmail.com>
Date		: 2009-04-22 19:07 (4 days old)
=46irst-Bad-Commit: http://git.kernel.org/?p=3Dlinux/kernel/git/torvald=
s/linux-2.6.git;a=3Dcommit;h=3D2f9092e1020246168b1309b35e085ecd7ff9ff72
Handled-By	: Jeff Mahoney <jeffm@suse.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13148
Subject		: resume after suspend-to-ram broken on Sony Vaio VGN-SR19VN w=
hen sony-laptop driver present
Submitter	: fanderay <fanderay4@googlemail.com>
Date		: 2009-04-22 14:39 (4 days old)
Handled-By	: Mattia Dongili <malattia@linux.it>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13126
Subject		: BUG: MAX_LOCKDEP_ENTRIES too low! when mounting rootfs
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2009-04-15 12:43 (11 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D123979949820538&w=3D=
4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13124
Subject		: ioatdma: DMA-API: device driver frees DMA memory with wrong =
function
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2009-04-09 12:36 (17 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D123928064322503&w=3D=
4
Handled-By	: Dan Williams <dan.j.williams@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13122
Subject		: reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2009-04-16 19:23 (10 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D123990989515105&w=3D=
4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13119
Subject		: Trouble with make-install from a NFS mount
Submitter	: Gregory Haskins <ghaskins@novell.com>
Date		: 2009-04-14 21:32 (12 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D123974482327044&w=3D=
4
Handled-By	: H. Peter Anvin <hpa@zytor.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13118
Subject		: iptables very slow after commit 784544739a25c30637397ace5489=
eeb6e15d7d49
Submitter	: Jeff Chua <jeff.chua.linux@gmail.com>
Date		: 2009-04-10 16:05 (16 days old)
References	: http://lkml.org/lkml/2009/4/10/111
Handled-By	: Eric Dumazet <dada1@cosmosbay.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13116
Subject		: Can't boot with nosmp
Submitter	: Stephen Hemminger <shemminger@vyatta.com>
Date		: 2009-04-15 4:18 (11 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D123976917817920&w=3D=
4
Handled-By	: Dan Williams <dan.j.williams@intel.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13114
Subject		: USB storage (usbstick) automount woes
Submitter	: Mike Galbraith <efault@gmx.de>
Date		: 2009-04-09 9:26 (17 days old)
=46irst-Bad-Commit: http://git.kernel.org/?p=3Dlinux/kernel/git/torvald=
s/linux-2.6.git;a=3Dcommit;h=3De6e244b6cb1f70e7109381626293cd40a8334ed3
References	: http://marc.info/?l=3Dlinux-kernel&m=3D123926928907568&w=3D=
4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13111
Subject		: Linux 2.6.30-rc1 tg3 endian issues with MAC addresses on BCM=
5701
Submitter	: Robin Holt <holt@sgi.com>
Date		: 2009-04-08 7:12 (18 days old)
=46irst-Bad-Commit: http://git.kernel.org/?p=3Dlinux/kernel/git/torvald=
s/linux-2.6.git;a=3Dcommit;h=3De4f341103e4a2b35f56a0f89802f1b1448e8d04b
References	: http://marc.info/?l=3Dlinux-kernel&m=3D123917477312823&w=3D=
4
		  http://lkml.org/lkml/2009/4/16/471
Handled-By	: Matt Carlson <mcarlson@broadcom.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13108
Subject		: 2.6.30-rc1: white screen during boot (regression) on spitz
Submitter	: Pavel Machek <pavel@ucw.cz>
Date		: 2009-04-10 10:34 (16 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D123935954223418&w=3D=
4
Handled-By	: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13107
Subject		: LTP 20080131 causes defunct processes w/2.6.30-rc1
Submitter	: Kumar Gala <galak@kernel.crashing.org>
Date		: 2009-04-09 15:43 (17 days old)
=46irst-Bad-Commit: http://git.kernel.org/?p=3Dlinux/kernel/git/torvald=
s/linux-2.6.git;a=3Dcommit;h=3Db3bfa0cba867f23365b81658b47efd906830879b
References	: http://marc.info/?l=3Dlinux-kernel&m=3D123929187208953&w=3D=
4
		  http://lkml.org/lkml/2009/4/10/193
Handled-By	: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13101
Subject		: BUG: scheduling while atomic: swapper/0/0x10000100
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2009-04-07 7:37 (19 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D123908995822195&w=3D=
4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13069
Subject		: regression in 2.6.29-git3 on SH/Dreamcast
Submitter	: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Date		: 2009-03-29 19:04 (28 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D123835353115372&w=3D=
4


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13068
Subject		: Lockdep warining in inotify_dev_queue_event
Submitter	: Sachin Sant <sachinp@in.ibm.com>
Date		: 2009-04-05 12:37 (21 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D123893439229272&w=3D=
4


Regressions with patches
------------------------

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13185
Subject		: New x86 warning
Submitter	: Jeff Garzik <jeff@garzik.org>
Date		: 2009-04-22 6:46 (4 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D124038280020950&w=3D=
4
Handled-By	: Andi Kleen <andi@firstfloor.org>
Patch		: http://patchwork.kernel.org/patch/19330/
		  http://patchwork.kernel.org/patch/19406/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13176
Subject		: IO-APIC + timer doesn't work!
Submitter	: Jeff Mahoney <jeffm@suse.com>
Date		: 2009-04-17 15:15 (9 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D123998145109946&w=3D=
4
Handled-By	: Andreas Herrmann <andreas.herrmann3@amd.com>
Patch		: http://patchwork.kernel.org/patch/19378/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13173
Subject		: NULL pointer crash in early NMI handler
Submitter	: Steven Rostedt <rostedt@goodmis.org>
Date		: 2009-04-21 1:35 (5 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D124027774713368&w=3D=
4
Handled-By	: Rusty Russell <rusty@rustcorp.com.au>
Patch		: http://patchwork.kernel.org/patch/19141/
		  http://patchwork.kernel.org/patch/19140/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13165
Subject		: 2.6.30-rc3 : Regression: i915 , video
Submitter	: We La <w.landgraf@yahoo.com>
Date		: 2009-04-23 19:19 (3 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D124051473119134&w=3D=
4
		  http://marc.info/?l=3Dlinux-kernel&m=3D124062673404329&w=3D4
Handled-By	: Len Brown <lenb@kernel.org>
Patch		: http://patchwork.kernel.org/patch/18420/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13136
Subject		: possible circular locking dependency detected while suspendi=
ng laptop to S3
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2009-04-18 11:17 (8 days old)
Handled-By	: Oliver Neukum <oliver@neukum.org>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=3D13136#c1


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13125
Subject		: active uvcvideo breaks over suspend
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2009-04-15 10:12 (11 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D123979009508840&w=3D=
4
Handled-By	: Ming Lei <tom.leiming@gmail.com>
Patch		: http://lkml.org/lkml/2009/4/18/5


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13121
Subject		: ACPI: Failed to switch the brightness - acer aspire 5720G
Submitter	: Maxim Levitsky <maximlevitsky@gmail.com>
Date		: 2009-04-16 11:37 (10 days old)
=46irst-Bad-Commit: http://git.kernel.org/?p=3Dlinux/kernel/git/torvald=
s/linux-2.6.git;a=3Dcommit;h=3D1a7c618a3f7bef1a20ae740df512eeba21397fa5
References	: http://marc.info/?l=3Dlinux-kernel&m=3D123988189401913&w=3D=
4
Handled-By	: Zhang Rui <rui.zhang@intel.com>
Patch		: http://patchwork.kernel.org/patch/19755/


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13109
Subject		: High latency on /sys/class/thermal
Submitter	: Tiago Sim=C3=B5es Batista <tiagosbatista@gmail.com>
Date		: 2009-04-11 14:56 (15 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D123946182301248&w=3D=
4
Handled-By	: Zhang Rui <rui.zhang@intel.com>
		  Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=3D21061


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13067
Subject		: iwl3945: wlan0: beacon loss from AP - sending probe request
Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
Date		: 2009-04-05 9:11 (21 days old)
References	: http://marc.info/?l=3Dlinux-kernel&m=3D123892272218266&w=3D=
4
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=3D13067#c6


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D13048
Subject		: /sys/class/backlight/acpi_video0/* is gone on vaio laptop wi=
th Intel GM45.
Submitter	: Rodrigo L. Batista <rodrigo@gus-mg.org>
Date		: 2009-04-09 04:57 (17 days old)
Handled-By	: yakui_zhao <yakui.zhao@intel.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=3D20967
		  http://bugzilla.kernel.org/attachment.cgi?id=3D20959


=46or details, please visit the bug entries and follow the links given =
in
references.

As you can see, there is a Bugzilla entry for each of the listed regres=
sions.
There also is a Bugzilla entry used for tracking the regressions from 2=
=2E6.29,
unresolved as well as resolved, at:

http://bugzilla.kernel.org/show_bug.cgi?id=3D13070

Please let me know if there are any Bugzilla entries that should be add=
ed to
the list in there.

Thanks,
Rafael

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
