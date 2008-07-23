Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266AbYGWIGM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 04:06:12 -0400
Date: Wed, 23 Jul 2008 01:05:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Fran=E7ois?= Valenduc
	<francois.valenduc@tvcablenet.be>
Cc: bugme-daemon@bugzilla.kernel.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>
Subject: Re: [Bugme-new] [Bug 11144] New: dhcp doesn't work with iwl4965
Message-Id: <20080723010522.389a948f.akpm@linux-foundation.org> (sfid-20080723_100618_835381_FDAFF708)
In-Reply-To: <4886E49D.6010700@tvcablenet.be>
References: <bug-11144-10286@http.bugzilla.kernel.org/>
	<20080722034850.dbbc5566.akpm@linux-foundation.org>
	<4886E49D.6010700@tvcablenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 23 Jul 2008 09:58:21 +0200 Fran__ois Valenduc <francois.valenduc@tvcablenet.be> wrote:

> P.S: why don't you want to use the bugzilla interface ?

Depends on the subsystem.  ACPI is 100% bugzilla-based, net people 
prefer email, others are in-between.

Plus for recently-occurring bugs it's best to knock them over via email
without getting into bugzilla bureaucracy.  bugzilla is more
appropriate to longer-term bugs.

And when the bug affects multiple subsystems, multiple
developers and we don't even know which subsystem introduced it, it is
much better to perform the diagnosis and repair via email.


I make a judgement call on each report.  Been doing it for a while,
don't get too many complaints ;)
