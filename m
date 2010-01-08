Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27148 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab0AHVIp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 16:08:45 -0500
Subject: Re: [PATCH 0/2] iwlwifi fixes for 2.6.33
From: reinette chatre <reinette.chatre@intel.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1262973871-2483-1-git-send-email-reinette.chatre@intel.com>
References: <1262973871-2483-1-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Fri, 08 Jan 2010 13:08:44 -0800
Message-Id: <1262984924.11849.4782.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-01-08 at 10:04 -0800, Chatre, Reinette wrote:
> I had some problems compiling wireless-2.6 as I ran into the problem
> described in http://patchwork.kernel.org/patch/68463/ . I assume that the
> "CONFIG_KPROBES=n" relies on patch "[PATCH] x86: compile insn.c and inat.c
> only for KPROBES", which is not present in wireless-2.6. I am using
> gawk. For testing I manually applied this patch and disabled kprobes to be
> able to build.

This problem went away after I upgraded gawk from 3.1.6 to 3.1.7.

Reinette


