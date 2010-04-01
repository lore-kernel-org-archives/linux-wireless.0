Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17047 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756658Ab0DAPpu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 11:45:50 -0400
Subject: Re: Intel Corporation PRO/Wireless 4965 AG or AGN randomly shuts
 off
From: reinette chatre <reinette.chatre@intel.com>
To: Jeremi Thebeau <jeremi.thebeau@googlemail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <g2s4c251d3f1004010026rbb8030e0pc820fa75c96df52e@mail.gmail.com>
References: <m2j4c251d3f1003302243z67d9c5f0v93cec04fb3543ceb@mail.gmail.com>
	 <1270056176.2446.3494.camel@rchatre-DESK>
	 <g2s4c251d3f1004010026rbb8030e0pc820fa75c96df52e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 08:45:49 -0700
Message-ID: <1270136749.2276.1312.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-01 at 00:26 -0700, Jeremi Thebeau wrote:
> I haven't played around much with ucode, linux modules, dirver and
> applying patches. Do you have a suggestion for a good primer. I will
> try to make sense of that ridiculously long bug when i get a chance.
> Assuming I am able to install and patch, if the device drops off
> again, are there any specific logs I should keep an eye on to help
> test this patch?

There is no need to read the entire bug report. Only the comment linked
to at http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2037#c112
can be taken independently. You can read more about building and
patching the kernel in the README file that accompanies the kernel
source code. I believe http://www.kroah.com/lkn/ is also a good primer.
Hopefully that patch will return you a working system, if not then we
can look into which debugging to enable based on the symptoms you
experience at that time.

Reinette




