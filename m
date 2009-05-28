Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbZE1HDG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 03:03:06 -0400
Date: Thu, 28 May 2009 00:02:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-wireless@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, dandart@googlemail.com
Subject: Re: [Bugme-new] [Bug 13317] New: No rt2x00 modules in RT kernels.
Message-Id: <20090528000253.c731179c.akpm@linux-foundation.org>
In-Reply-To: <bug-13317-10286@http.bugzilla.kernel.org/>
References: <bug-13317-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Fri, 15 May 2009 17:53:46 GMT bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=13317
> 
>            Summary: No rt2x00 modules in RT kernels.
>            Product: Alternate Trees
>            Version: 2.5
>     Kernel Version: 2.6.29+
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: rt
>         AssignedTo: alt-trees_rt@kernel-bugs.osdl.org
>         ReportedBy: dandart@googlemail.com
>         Regression: No
> 
> 
> Is there a problem with using rt2x00 kernel modules with realtime kernels?
> In the info page it says that they need the symbol "BROKEN" which is probably
> to tell us that we can't use it. I can't compile it into kernels with an RT
> patch.
> Why? What's wrong with this mix of module and tree? Is there any way to make
> them happily coexist?
> 

Good question, but bugzilla isn't a good place to ask it.

Presumably there's some bustage in the rt2x00 driver which makes it not
work with -rt kernels.

Did the -rt guys tell the wireless guys about this?
