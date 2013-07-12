Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30756 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884Ab3GLQzp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 12:55:45 -0400
Message-ID: <1373648143.17876.98.camel@gandalf.local.home> (sfid-20130712_185553_561187_B4FDAF50)
Subject: Re: Help adding trace events to xHCI
From: Steven Rostedt <rostedt@goodmis.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Xenia Ragiadakou <burzalodowa@gmail.com>,
	OPW Kernel Interns List <opw-kernel-interns@googlegroups.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-trace-users@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Date: Fri, 12 Jul 2013 12:55:43 -0400
In-Reply-To: <20130712164104.GA15531@xanatos>
References: <51DB0257.1010709@gmail.com> <20130711162002.GA5240@xanatos>
	 <1373562533.8201.33.camel@jlt4.sipsolutions.net>
	 <20130711190035.GD5240@xanatos> <87y59c4d60.fsf@kamboji.qca.qualcomm.com>
	 <20130712164104.GA15531@xanatos>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-07-12 at 09:41 -0700, Sarah Sharp wrote:
> On Fri, Jul 12, 2013 at 07:25:59AM +0300, Kalle Valo wrote:

> Thanks for the suggestion.  I'm not familiar with all the userspace
> tools for trace events, so I didn't know about the command parser.  Is
> there documentation or a list of resources for all the userspace trace
> event plugins?  If so, can you give us a pointer to it?
> 

Currently the plugins only exist in trace-cmd. But there's going to be
work done to get them into the kernel tools directory. I was just
talking with Jiri about this today. Perf will require it.

trace-cmd repo is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

-- Steve


