Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41760 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab0CQFfH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 01:35:07 -0400
Subject: Re: iwl3945 and power saving
From: reinette chatre <reinette.chatre@intel.com>
To: Stefan Monnier <monnier@iro.umontreal.ca>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <jwvwrxbimib.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
References: <jwvwrxbimib.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 22:35:05 -0700
Message-ID: <1268804105.2446.620.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefan,

On Tue, 2010-03-16 at 21:49 -0700, Stefan Monnier wrote:

> The extra power consumption is quite significant, so I'm considering
> compiling my own driver, manually re-enabling the power-saving code.

You will need to revert "iwl3945: disable power save" and then also
enable power savings using "iwconfig wlanX power on"

> 
> But before I do that, I'd like to know what is the risk involved (it
> seems pretty serious since it warranted removing the feature
> altogether, even tho it was runtime-disabled by default anyway).

You should find all the details in
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2125

Reinette


