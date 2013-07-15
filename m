Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab3GONsH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 09:48:07 -0400
Date: Mon, 15 Jul 2013 15:47:55 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Xenia Ragiadakou <burzalodowa@gmail.com>,
	OPW Kernel Interns List <opw-kernel-interns@googlegroups.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-trace-users@vger.kernel.org
Subject: Re: Help adding trace events to xHCI
Message-ID: <20130715134755.GD4571@krava.redhat.com> (sfid-20130715_154814_388636_B1841BE8)
References: <51DB0257.1010709@gmail.com>
 <20130711162002.GA5240@xanatos>
 <1373562533.8201.33.camel@jlt4.sipsolutions.net>
 <20130711190035.GD5240@xanatos>
 <87y59c4d60.fsf@kamboji.qca.qualcomm.com>
 <20130712164104.GA15531@xanatos>
 <1373648143.17876.98.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1373648143.17876.98.camel@gandalf.local.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 12, 2013 at 12:55:43PM -0400, Steven Rostedt wrote:
> On Fri, 2013-07-12 at 09:41 -0700, Sarah Sharp wrote:
> > On Fri, Jul 12, 2013 at 07:25:59AM +0300, Kalle Valo wrote:
> 
> > Thanks for the suggestion.  I'm not familiar with all the userspace
> > tools for trace events, so I didn't know about the command parser.  Is
> > there documentation or a list of resources for all the userspace trace
> > event plugins?  If so, can you give us a pointer to it?
> > 
> 
> Currently the plugins only exist in trace-cmd. But there's going to be
> work done to get them into the kernel tools directory. I was just
> talking with Jiri about this today. Perf will require it.

hi,
I made initial backport but got distracted.. ;-)
I'll refresh those patches and resend them out soon..

jirka
