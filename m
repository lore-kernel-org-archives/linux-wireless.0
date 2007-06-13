Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16304 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbXFMGEV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 02:04:21 -0400
Subject: Re: [PATCH 2/6] mac80211: remove global tsinfo debugfs variables
From: Zhu Yi <yi.zhu@intel.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070612133608.5f6e9b60@logostar.upir.cz>
References: <20070608170342.GA17253@mail.intel.com>
	 <1181331767.6533.98.camel@johannes.berg>
	 <1181530652.3042.27.camel@debian.sh.intel.com>
	 <20070612133608.5f6e9b60@logostar.upir.cz>
Content-Type: text/plain
Date: Wed, 13 Jun 2007 14:03:05 +0800
Message-Id: <1181714585.4758.64.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-06-12 at 13:36 +0200, Jiri Benc wrote:
> Johannes probably meant a binary blob prepared by user space. That still
> complies to the one value per file rule.

Right, but that is not easy to use (i.e with `echo` or `cat`) without
writting a user space program.

> > The DLS is easier because it only has one parameter (peer mac address)
> > now. I programed it the same way as tspec. So when we find to need more
> > parameters for DLS setup, we can add another debugfs file for the new
> > parameter instead of combining multiple parameters in one file.
> > 
> > I'd agree I didn't pay a lot of attentions to the debugfs interface
> > design since I thought it was used for occasional debug only. Please
> > tell me what which do you prefer: one value per file or multiple values
> > per file so that we can do one shot parameter passing? So I don't need
> > to switch them back and forth.
> 
> Depends on how long you want to keep this debugfs interface. If it's just a
> few months matter and it's never going to hit vanilla, it's probably not
> worth the effort to rewrite it.

I'm working with Johannes with the API define. When this is done,
hopfully we can remove the debugfs stuff.

Thanks,
-yi
