Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54701 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419AbZIKVMW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 17:12:22 -0400
Subject: Re: [PATCH 07/13] iwlwifi: clean up ht config a little
From: reinette chatre <reinette.chatre@intel.com>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <69e28c910909111046m23414728nb9b56c53960340ea@mail.gmail.com>
References: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
	 <1252690699-25796-8-git-send-email-reinette.chatre@intel.com>
	 <69e28c910909111046m23414728nb9b56c53960340ea@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Sep 2009 14:12:25 -0700
Message-Id: <1252703545.26521.143.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gábor,

On Fri, 2009-09-11 at 10:46 -0700, Gábor Stefanik wrote:
> On Fri, Sep 11, 2009 at 7:38 PM, Reinette Chatre
> <reinette.chatre@intel.com> wrote:
> > From: Johannes Berg <johannes@sipsolutions.net>
> >
> > is_ht can be bool instead of u8, and there's
> > no need to use IWL_CHANNEL_WIDTH_* constants
> > in supported_chan_width when that could just
> > be named is_40mhz instead.
> 
> What about is_ht40?

It seems that this structure distinguishes explicitly between being ht
(with "is_ht") and the supported channel width (now with "is_40mhz"). To
me it seems a bit awkward to have "is_ht" and "is_ht40". As you can tell
Johannes has been cleaning this up, so maybe he noticed a way in which
this can be clarified.

Reinette


