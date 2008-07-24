Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:17471 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757245AbYGXN66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 09:58:58 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [ipw3945-devel] iwl3945 random firmware crashes
Date: Thu, 24 Jul 2008 06:56:28 -0700
Message-ID: <4220499A1B034C4FA93B547BA01E1FF0017469F4@orsmsx413.amr.corp.intel.com> (sfid-20080724_155916_432591_2C328B90)
In-reply-to: <f6ca9fed0807240617n47180bb6t8691723e10d6fd9a@mail.gmail.com>
References: <f6ca9fed0807140437i2563cfa1ge68a06ef1040d0f8@mail.gmail.com><4220499A1B034C4FA93B547BA01E1FF0017469B4@orsmsx413.amr.corp.intel.com><f6ca9fed0807170423x7f7bd534x5ab63f985564f92@mail.gmail.com><f6ca9fed0807170428i4b386e46sb030316343f4bd4a@mail.gmail.com><f6ca9fed0807181235i33125343qab4804b675bafdf9@mail.gmail.com> <f6ca9fed0807240617n47180bb6t8691723e10d6fd9a@mail.gmail.com>
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: "drago01" <drago01@gmail.com>
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel" <ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oops, sorry about that, some of your emails slipped by me unnoticed!
:-(

Event and Error Logs need to be analyzed here ... It looks like an
internal error, timing out while waiting for something.  I'll need to
check to see if any updates to Windows uCode have helped this situation.

-- Ben --  

> -----Original Message-----
> From: ipw3945-devel-bounces@lists.sourceforge.net 
> [mailto:ipw3945-devel-bounces@lists.sourceforge.net] On 
> Behalf Of drago01
> Sent: Thursday, July 24, 2008 9:18 AM
> To: Cahill, Ben M
> Cc: linux-wireless; ipw3945-devel
> Subject: Re: [ipw3945-devel] iwl3945 random firmware crashes
> 
> On Fri, Jul 18, 2008 at 9:35 PM, drago01 <drago01@gmail.com> wrote:
> > On Thu, Jul 17, 2008 at 1:28 PM, drago01 <drago01@gmail.com> wrote:
> >> On Thu, Jul 17, 2008 at 1:23 PM, drago01 <drago01@gmail.com> wrote:
> >>> On Mon, Jul 14, 2008 at 8:05 PM, Cahill, Ben M 
> <ben.m.cahill@intel.com> wrote:
> >>>> Try loading driver using module param:
> >>>>
> >>>> debug=0x43fff
> >>>>
> >>>> This will provide more information in the log, including 
> an event 
> >>>> log (where you see "Microcode SW Error detected" in your 
> log, you 
> >>>> would have captured Event Log if you had the 
> debug=0x43fff setting).
> >>>
> >>> It happend again and this time I captured the log.
> >>> Debug output including event log is attached.
> >>>
> >>
> >> Resend with compressed attachment.
> >>
> >
> > Happend again ... is there a tool that "decrypts" the event 
> log to be readable?
> > The whole thing does not make any sense to me and the log does not 
> > tell me what is really happening to debug it.
> 
> Happened more time ... Ben any idea whats going on?
> 
> --------------------------------------------------------------
> -----------
> This SF.Net email is sponsored by the Moblin Your Move 
> Developer's challenge Build the coolest Linux based 
> applications with Moblin SDK & win great prizes Grand prize 
> is a trip for two to an Open Source event anywhere in the 
> world http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
> 
