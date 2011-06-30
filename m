Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6444 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab1F3XQq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 19:16:46 -0400
Subject: Re: iwlagn: Problems with Intel Wifi Link 1000 on newer kernels
From: wwguy <wey-yi.w.guy@intel.com>
To: Erik Hardesty <ehardesty@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <BANLkTinEJ_XZcrV-SwRRJ=r1Heo0-YBhfA@mail.gmail.com>
References: <BANLkTim83iarV-J08JAsVtfLR2ziqLs=iQ@mail.gmail.com>
	 <20110630095137.GA2666@redhat.com>	<1309443595.25768.1.camel@wwguy-ubuntu>
	 <BANLkTinEJ_XZcrV-SwRRJ=r1Heo0-YBhfA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 16:12:49 -0700
Message-ID: <1309475569.26211.3.camel@wwguy-ubuntu> (sfid-20110701_011650_186250_5A7AB9BF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-06-30 at 16:12 -0700, Erik Hardesty wrote:
> Forcing iwlwifi-1000-3.ucode results in the same issues. No change in
> linux 3.0-rc5.
> 
> On Thu, Jun 30, 2011 at 9:19 AM, wwguy <wey-yi.w.guy@intel.com> wrote:
> > On Thu, 2011-06-30 at 02:51 -0700, Stanislaw Gruszka wrote:
> >> On Fri, Jun 17, 2011 at 01:14:11AM -0500, Erik Hardesty wrote:
> >> > Having trouble with iwlagn in kernels newer than 2.6.38.
> >> > I've tried 2.6.39 and 3.0rc3 and both give me the same problem.
> >> > I have the latest intel firmware installed on the system. Both
> >> > iwlwifi-1000-3.ucode
> >> > and iwlwifi-1000-5.ucode are in /lib/firmware
> >> >
> >> > Note: 2.6.38 does not exhibit the same issue and works fine.
> >>
> >> If there is no other proposition to fix the issue from Intel,
> >> perhaps you could bisect the problem.
> >
> > what if you remove iwlwifi-1000-5.ucode and force to use -3 version of
> > uCode; are you still seeing the problem with new kernel?
> >
then no idea :-(, maybe has to bisect it.

what exactally the problem you facing, do you have a bugzilla# ?

Thanks
Wey
> >
> >
> >


