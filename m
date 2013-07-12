Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757610Ab3GLTf7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 15:35:59 -0400
Date: Fri, 12 Jul 2013 21:35:31 +0200
From: Mark Wielaard <mjw@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Xenia Ragiadakou <burzalodowa@gmail.com>,
	OPW Kernel Interns List <opw-kernel-interns@googlegroups.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-trace-users@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: Help adding trace events to xHCI
Message-ID: <20130712193531.GA6954@toonder.wildebeest.org> (sfid-20130712_213628_655120_BF1ACAA8)
References: <51DB0257.1010709@gmail.com>
 <20130711162002.GA5240@xanatos>
 <1373562533.8201.33.camel@jlt4.sipsolutions.net>
 <20130711190035.GD5240@xanatos>
 <87y59c4d60.fsf@kamboji.qca.qualcomm.com>
 <20130712164104.GA15531@xanatos>
 <20130712170827.GA18819@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130712170827.GA18819@Krystal>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mathieu,

On Fri, Jul 12, 2013 at 01:08:28PM -0400, Mathieu Desnoyers wrote:
> * Sarah Sharp (sarah.a.sharp@linux.intel.com) wrote:
> > Thanks for the suggestion.  I'm not familiar with all the userspace
> > tools for trace events, so I didn't know about the command parser.  Is
> > there documentation or a list of resources for all the userspace trace
> > event plugins?  If so, can you give us a pointer to it?
> 
> You might want to try out LTTng-UST. It provides TRACEPOINT_EVENT() and
> tracepoint() for user-space instrumentation. See:
> 
> - https://lttng.org/files/doc/man-pages/man3/lttng-ust.3.html

Is that build on the <sys/sdt.h> ust probe points as embedded in glibc
for example that gdb and systemtap use to access user space trace
points? Can tools use lttng-ust and <sys/sdt.h> tracepoints
interchangeably by parsing the ELF notes described in
http://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation

Thanks,

Mark
