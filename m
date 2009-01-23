Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53561 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757085AbZAWQvN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 11:51:13 -0500
Subject: Re: Kernel Compile Fail with 2.6.26 Drivers
From: reinette chatre <reinette.chatre@intel.com>
To: Delphi Real Estate <Info@delphi-real-estate.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <200901230550.25986.Info@delphi-real-estate.com>
References: <200901200942.57618.Info@delphi-real-estate.com>
	 <200901230550.25986.Info@delphi-real-estate.com>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 08:53:49 -0800
Message-Id: <1232729629.4501.37.camel@rc-desk> (sfid-20090123_175118_752836_7D13D599)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-01-23 at 05:50 -0800, Delphi Real Estate wrote:
> It seems that either no one has 'n' working at 5GHz, or are not willing to advise.  All I need is a combination that works;  I've tried 2.6's iwlwifi in 2.6.27 and it won't compile, and it seems that 2.6.28's iwlwifi doesn't work in 'n'.  I've run Debian for eleven years and have always compiled my own custom kernels, but would very much like to get 'n' working.  Scripting is no problem, although I am not an actual coder.  I wish someone could pitch in briefly.

As a summary of our discussion so far:

80211n currently works, except that you will get slower speeds because
TX aggregation is not working.

If you want TX aggregation support then you can use the iwl5000 branch
of the iwlwifi-2.6 repo on git.kernel.org, which is based on kernel
2.6.26.

We are working on getting TX aggregation working again.

Reinette



