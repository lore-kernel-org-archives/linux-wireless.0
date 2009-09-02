Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:33638 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbZIBQyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 12:54:15 -0400
Subject: Re: [PATCH 2.6.31] iwlwifi: Reenable power_level
From: reinette chatre <reinette.chatre@intel.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <cb0375e10909020941qa54215cqb6af7ac01e87ccb3@mail.gmail.com>
References: <cb0375e10909020753o4d314f61k74dd35025f61666a@mail.gmail.com>
	 <1251906970.13180.137.camel@rc-desk>
	 <cb0375e10909020941qa54215cqb6af7ac01e87ccb3@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 02 Sep 2009 09:54:17 -0700
Message-Id: <1251910457.13180.160.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrew,

On Wed, 2009-09-02 at 09:41 -0700, Andrew Lutomirski wrote:

> Fair enough.  Would you accept a patch to remove power_level from sysfs instead?

No. This file is used when users want to manually reduce the power used
by device. This is the file you want to change if you want to extend
your battery life.

> >> This fixes what looks to me like a regression: power_level used to
> >> work but now fails silently.  In 2.6.32 I think this code is going
> >> away, but this patch seems like a safe stopgap measure.
> >
> > 2.6.32 will have power save support disabled also.
> 
> Any ETA for getting this fixed for real?  I like my battery life :)

We are working on it.

Reinette


