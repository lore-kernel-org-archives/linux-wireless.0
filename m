Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144Ab1H1TuR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Aug 2011 15:50:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110828193519.GA14132@redhat.com>
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera> <20110828193519.GA14132@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 28 Aug 2011 12:49:26 -0700
Message-ID: <CA+55aFxuTmfE3iFL7ko=9ZWDuxenssw69hyEG3bgQxy_QDqgZA@mail.gmail.com> (sfid-20110828_215042_138139_A65D377B)
Subject: Re: 3.1-rc3-git6: Reported regressions from 3.0
To: Dave Jones <davej@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Florian Mickler <florian@mickler.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	Linux ACPI <linux-acpi@vger.kernel.org>,
	Linux PM List <linux-pm@lists.linux-foundation.org>,
	Linux SCSI List <linux-scsi@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 28, 2011 at 12:35 PM, Dave Jones <davej@redhat.com> wrote:
> On Sun, Aug 28, 2011 at 08:22:05PM +0200, Rafael J. Wysocki wrote:
>
>  > Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=41742
>  > Subject              : duplicate filename  for intel_backlight with the i915 driver
>  > Submitter    : François Valenduc <francois.valenduc@tvcablenet.be>
>  > Date         : 2011-08-25 18:51 (4 days old)
>  > First-Bad-Commit: http://git.kernel.org/linus/aaa6fd2a004147bf32fce05720938236de3361d9
>
> this should be fixed by b727d20269e8ef1de002bfea8099f5e9db9e9f23

Actually, by a2cc797d2d1a ("i915: do not setup intel_backlight ").

That b727d20269e is just my merge commit that brings in the fix (and
the bogus initialization of 'locked') into mainline.

                   Linus
