Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33734 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab0HRT0e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 15:26:34 -0400
Subject: Re: [PATCH 2/2] iwlwifi: use long monitor timer to avoid
 un-necessary reload
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: drago01 <drago01@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <AANLkTikEKbHNtG0A=QdoxytSyBpG247=zdXOj1FmQ8Lw@mail.gmail.com>
References: <1282153819-27781-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1282153819-27781-3-git-send-email-wey-yi.w.guy@intel.com>
	 <AANLkTikEKbHNtG0A=QdoxytSyBpG247=zdXOj1FmQ8Lw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 12:30:55 -0700
Message-ID: <1282159855.27858.1.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-08-18 at 11:50 -0700, drago01 wrote:
> On Wed, Aug 18, 2010 at 7:50 PM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> >
> > For 5000 series of devices, use long monitor timer to check
> > stuck tx queues.
> >
> > 5000 series device, it is being reported firmware got reload more
> > often than necessary, so extend the timer to avoid un-necessary reload.
> 
> What about iwl5300 ?
> As I noted in the other thread my 5300 was affected by said issue and
> increasing the timeout fixed it.
> 
I am not aware of 5300 also having similar issues; I all submit follow
up patch to extend the timeout value for 5300 device.

Thanks
Wey


