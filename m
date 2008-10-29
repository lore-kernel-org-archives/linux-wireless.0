Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39234 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbYJ2Mzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 08:55:49 -0400
Date: Wed, 29 Oct 2008 08:54:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-ia64@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-wireless@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <Joel.Becker@oracle.com>, gregkh@suse.de
Subject: Re: linux-next: Tree for October 28
Message-ID: <20081029125449.GD24103@tuxdriver.com> (sfid-20081029_135555_269099_E3D1BFE4)
References: <20081028183055.fbcf5420.sfr@canb.auug.org.au> <20081028220741.f5d331ba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081028220741.f5d331ba.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2008 at 10:07:41PM -0700, Andrew Morton wrote:
> On Tue, 28 Oct 2008 18:30:55 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> > (patches at
> > http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).

> and wireless needs some Kconfig help.  Please don't just break other
> architecture's build like this.
> 
> drivers/staging/wlan-ng/wlan_compat.h:136:3: #error "No CPU identified!"
> drivers/staging/wlan-ng/wlan_compat.h:695:6: warning: "WLAN_CPU_FAMILY" is not defined
> drivers/staging/wlan-ng/wlan_compat.h:699:6: warning: "WLAN_CPU_FAMILY" is not defined

For the record, I blame Greg K-H for this... :-)

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
