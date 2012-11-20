Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53632 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab2KTWgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 17:36:16 -0500
Date: Tue, 20 Nov 2012 16:36:09 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Daniel Wagner <wagi@monom.org>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH v2 00/22] brcmsmac: Tx rework and expanded debug/trace
 support
Message-ID: <20121120223609.GD26602@thinkpad-t410> (sfid-20121120_233618_209564_C163D3A1)
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <50AA845C.2050809@monom.org>
 <50AB3182.5040505@monom.org>
 <20121120142822.GA26602@thinkpad-t410>
 <50ABC168.8080904@monom.org>
 <50ABF17A.6020604@broadcom.com>
 <20121120211647.GC26602@thinkpad-t410>
 <50ABFB6F.3040409@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50ABFB6F.3040409@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 20, 2012 at 10:51:43PM +0100, Arend van Spriel wrote:
> On 11/20/2012 10:16 PM, Seth Forshee wrote:
> >On Tue, Nov 20, 2012 at 10:09:14PM +0100, Arend van Spriel wrote:
> >>>I hope I got it right. Here are the requested logs:
> >>>
> >>>http://www.monom.org/misc/brcmsmac/traces/
> >>
> >>What channel is you AP on?
> >
> >Based on the trace it looks like channel 13.
> 
> Think so too.
> 
> >If you want to take a look at the decoded trace data I've uploaded it to
> >http://people.canonical.com/~sforshee/brcms-trace/trace.log. I've got a
> >trace-cmd plugin for the tracepoints I added that makes it easier to
> >decipher.
> >
> >Seth
> >
> 
> Nice :-D Are you sharing it?

Yes, I plan to submit it for trace-cmd after the tracepoints get to
Linus's tree. I just uploaded it to
http://people.canonical.com/~sforshee/brcms-trace/brcmsmac.py if you'd
like to use it now though.

