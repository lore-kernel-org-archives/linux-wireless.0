Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32213 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759680AbZIPQaV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 12:30:21 -0400
Subject: Re: iwlagn rfkill and 2.6.31 on Intel Corporation PRO/Wireless
 5100 AGN
From: reinette chatre <reinette.chatre@intel.com>
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mjg@redhat.com" <mjg@redhat.com>
In-Reply-To: <200909161657.44453.fabio.coatti@gmail.com>
References: <200909161521.15710.fabio.coatti@gmail.com>
	 <20090916132549.GA10634@tuxdriver.com>
	 <200909161657.44453.fabio.coatti@gmail.com>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 09:30:19 -0700
Message-Id: <1253118619.26521.420.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Fabio,

On Wed, 2009-09-16 at 07:57 -0700, Fabio Coatti wrote:
> But the behaviour of wifi sybsystem is still weird, (maybe for some faults on 
> my side). Basically if the laptop starts with wifi enabled (rfkill off) 
> wpa_supplicant can establish a connection, that can be killed by rfkill switch 
> (both wifi and bluetooth seems to be killed). But when I turn off rfkill 
> switch wpa_supplicant is unable to connect again; looking at syslog/dmesg I 
> can see activity in bt stack, but no messages regarding wlan0.

I think at this point you need to bring the interface back up. When you
enable rfkill the interface is brought down, the opposite (bringing
interface up) is not done automatically when you disable rfkill.

Reinette


