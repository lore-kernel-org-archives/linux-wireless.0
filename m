Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:63659 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbZENRfq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 13:35:46 -0400
Subject: Re: [ipw3945-devel] iwlwifi 5150 uCode available
From: reinette chatre <reinette.chatre@intel.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <b170af450905141022q29f7a8cfl1c079e473f575c49@mail.gmail.com>
References: <1242321566.32358.19.camel@rc-desk>
	 <b170af450905141022q29f7a8cfl1c079e473f575c49@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 May 2009 10:42:20 -0700
Message-Id: <1242322940.32358.31.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, 2009-05-14 at 10:22 -0700, Rafał Miłecki wrote:
> 2009/5/14 reinette chatre <reinette.chatre@intel.com>:
> > uCode for Intel Wireless WiFi Link 5150AGN is now available for download
> > from http://intellinuxwireless.org/?n=Downloads
> 
> Changelog is top secret as usually? ;)

Nope ... this is the very first release of this uCode for this
particular hardware. A changelog does not make sense in this case.


> Should this fix
> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1946 (wrong
> command queue)?


This bug is against 5100/5300 hardware, so this uCode is not what you
are looking for. We are working on getting uCode for 5100/5300 hardware
(that includes a fix for this bug) out the door.

Reinette


