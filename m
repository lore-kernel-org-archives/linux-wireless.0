Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31436 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbZASSnx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 13:43:53 -0500
Subject: Re: Kernel Compile Fail with 2.6.26 Drivers
From: reinette chatre <reinette.chatre@intel.com>
To: Delphi Real Estate <Info@delphi-real-estate.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <200901190930.11401.Info@delphi-real-estate.com>
References: <200901190930.11401.Info@delphi-real-estate.com>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 10:46:13 -0800
Message-Id: <1232390773.11197.34.camel@rc-desk> (sfid-20090119_194414_027541_878A2B1E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-01-19 at 09:30 -0800, Delphi Real Estate wrote:
> Can anyone tell me what I'm doing wrong?  I know that 'n' has problems in later drivers than in kernel 2.6.26, so I am trying to graft the 2.6.26 drivers into the 2.6.27 kernel.  Source:
> http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=summary

If you want the driver with TX aggregation support then you need to use
the iwl5000 branch
( http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=shortlog;h=iwl5000 )


> I moved the regular Ubuntu kernel 2.6.27.10's iwlwifi directory elsewhere, and copied in Reinette's.  But it will not compile, inexplicably:

The branch is based on kernel 2.6.26. If you do not want to give up your
current kernel you can take a look how compat-wireless works ... but it
is actually intended to take the most recent wireless-testing to work
with your current kernel, not an older kernel in itself as what can be
found in the iwl5000 branch.

I think the easiest will be to use the iwl5000 branch on its own.

Reinette



