Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:40178 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbZKIWVA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 17:21:00 -0500
Subject: Re: [PATCH] iwlcore: Allow runtime configuration of
 no_sleep_autoadjust
From: reinette chatre <reinette.chatre@intel.com>
To: Andrew Lutomirski <andy@luto.us>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <cb0375e10911091007w45fa5653y8ed4f043f37074b6@mail.gmail.com>
References: <cb0375e10911081130k5d8f8347y999cf66a98e6898a@mail.gmail.com>
	 <1257787187.21134.22331.camel@rc-desk>
	 <cb0375e10911091007w45fa5653y8ed4f043f37074b6@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 14:21:05 -0800
Message-Id: <1257805265.21134.22738.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrew,

On Mon, 2009-11-09 at 10:07 -0800, Andrew Lutomirski wrote:
> Hmm.  It looks like sleep_level_override in debugfs can do exactly what I want.

You have not really stated what you are trying to do here so it is hard
to tell. sleep_level_override lets you hardcode the power saving index.

> 
> Is there any reason that no_sleep_autoadjust doesn't just make
> sleep_level_override default to 1?

That does seem what it is doing in iwl_power_update_mode().

Reinette


