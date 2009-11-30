Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40911 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbZK3VmI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 16:42:08 -0500
Subject: Re: Panic in iwl3945 driver
From: reinette chatre <reinette.chatre@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1259596551.4090.0.camel@maxim-laptop>
References: <1259167780.4072.2.camel@maxim-laptop>
	 <1259280022.3991.12.camel@maxim-laptop>
	 <1259596551.4090.0.camel@maxim-laptop>
Content-Type: text/plain
Date: Mon, 30 Nov 2009 13:42:13 -0800
Message-Id: <1259617333.4653.91.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-11-30 at 07:55 -0800, Maxim Levitsky wrote:
> > This is some very unpleasant problem.
> > The thing is that this happens very rarely, and while you use X.
> > I had recently few such embarrassing kernel panics (I never had any
> > random and rare kernel panics) and I strongly suspect them to be of same
> > origin.
> >
> > This one is first I captured, due to some code that I wrote recently
> > that saves printk buffer in predefined location in system ram that isn't
> > cleared on reboot in my notebook.
> >
> > I had put some NULL checks in iwl3945_rx_reply_tx, none did trigger yet,
> > nor I had another kernel panic.

Did this problem happen with your NULL checks in place? Can you perhaps
help here with which line the problem occurred? Any idea how to trigger
this?

Thank you

Reinette


