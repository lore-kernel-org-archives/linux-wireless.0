Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54350 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247Ab2CHVmP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 16:42:15 -0500
Date: Thu, 8 Mar 2012 15:42:06 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"Quan, David" <dquan@qca.qualcomm.com>,
	"Green, Michael" <green@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Problems with regulatory domain support and BCM43224
Message-ID: <20120308214205.GB13667@ubuntu-macmini> (sfid-20120308_224219_176746_66963D9D)
References: <20120308174101.GB28133@ubuntu-macmini>
 <CAB=NE6VapPfLjAh5Y+sCA4qA82s9HrQk_Mxr8FpKoCfjudMDig@mail.gmail.com>
 <4B96CD77D9161244899852B5F20DB5B70125BB72@nasanexd02d.na.qualcomm.com>
 <CAB=NE6U04a0XNrvt6HLCwqbHMtGL8CWh8No_=Bx0mwQZYEgGxQ@mail.gmail.com>
 <4B96CD77D9161244899852B5F20DB5B70125BC94@nasanexd02d.na.qualcomm.com>
 <CAB=NE6X9c1m63xayNsEf9XZ3AgPZDV2SiRivg3SV2Day83fPQA@mail.gmail.com>
 <20120308200734.GC28133@ubuntu-macmini>
 <4F591E14.4010000@broadcom.com>
 <CAB=NE6XnorRDEu976uMkPFNKHQjhRT0Craf3ZjL9dYysPjmQng@mail.gmail.com>
 <4F592542.7000005@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F592542.7000005@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 08, 2012 at 10:31:46PM +0100, Arend van Spriel wrote:
> >>Noticed your email yesterday, but did not get to chime into the
> >>conversation. brcmsmac does indeed provide a regulatory hint, which is
> >>either from SPROM or hard-coded to "US". Since "X0" is not a known
> >>regulatory domain for crda it does not make sense to pass it as a regulatory
> >>hint. However, the "full" story is told on linuxwireless.org (see [1]).
> >
> >The Linux kernel allows you to define custom regulatory domains, the
> >ath module uses these, it defines 13 of them. You can review that code
> >for an example of how to use them. So your X0 can still be used, you
> >just have to define the data structure.
> >
> 
> Thanks, Luis
> 
> I will dive into that.

Luis, Arend, thanks to both of you. Let me know if there's anything I
can do to help.

Seth

