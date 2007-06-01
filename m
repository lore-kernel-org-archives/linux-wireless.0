Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:4395 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758197AbXFAMVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 08:21:16 -0400
Received: by py-out-1112.google.com with SMTP id a29so884400pyi
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jun 2007 05:21:15 -0700 (PDT)
Message-ID: <46600F1C.5000302@googlemail.com>
Date: Fri, 01 Jun 2007 14:20:44 +0200
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Ingo Molnar <mingo@elte.hu>,
	=?ISO-8859-2?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
	linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
	Thierry Volpiatto <tvolpiatt@neuf.fr>,
	alsa-devel@alsa-project.org, Jaroslav Kysela <perex@suse.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Ben Collins <bcollins@ubuntu.com>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	Maximilian Engelhardt <maxi@daemonizer.de>
Subject: [1/3] 2.6.22-rc3: known regressions v2
Content-Type: text/plain; charset=ISO-8859-2
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Here is a list of some known regressions in 2.6.22-rc3.

=46eel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Unclassified

Subject    : build failed in function `vic_sys_interrupt'
References : http://lkml.org/lkml/2007/5/31/227
Submitter  : Toralf F=F6rster <toralf.foerster@gmx.de>
Status     : Unknown

Subject    : long freezes on thinkpad t60
References : http://lkml.org/lkml/2007/5/24/100
Submitter  : Miklos Szeredi <miklos@szeredi.hu>
Handled-By : Ingo Molnar <mingo@elte.hu>
Status     : problem is being debugged



ACPI

Subject    : unable to shutdown on kernel 2.6.22-rc2
References : http://bugzilla.kernel.org/show_bug.cgi?id=3D8516
Submitter  : Thierry Volpiatto <tvolpiatt@neuf.fr>
Status     : Unknown



ALSA

Subject    : snd-aoa causes badness in lib/kref.c:33
References : http://bugzilla.kernel.org/show_bug.cgi?id=3D8513
Submitter  : Ben Collins <bcollins@ubuntu.com>
Status     : Unknown



Networking

Subject    : b44: regression in 2.6.22
References : http://lkml.org/lkml/2007/5/27/108
Submitter  : Maximilian Engelhardt <maxi@daemonizer.de>
Handled-By : Michael Buesch <mb@bu3sch.de>
Status     : problem is being debugged



Regards,
Michal

--
"Najbardziej brakowa=B3o mi twojego milczenia."
-- Andrzej Sapkowski "Co=B6 wi=EAcej"

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
