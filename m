Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:61399 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1770952AbYHDVmh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 17:42:37 -0400
Subject: Re: The tiacx driver situation
From: Pavel Roskin <proski@gnu.org>
To: David Planella <david.planella@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, acx100-devel@lists.sourceforge.net,
	gregkh@suse.de, greg@kroah.com, xazz.xazz@googlemail.com,
	Andreas Mohr <andi@lisas.de>, andim2@users.sourceforge.net
In-Reply-To: <1d9d9b240808041147n5032160v252e1bc956c97902@mail.gmail.com>
References: <1d9d9b240808041147n5032160v252e1bc956c97902@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 17:42:34 -0400
Message-Id: <1217886154.9182.8.camel@dv> (sfid-20080804_234243_876959_16506E97)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-08-04 at 20:47 +0200, David Planella wrote:

> 3) Remove all public sources and start development from scratch,
> following clean-room procedures.
> This is the view I got from a short conversation with Johannes Berg on
> IRC, and would basically mean removing all sources and references to
> the current acx driver from the public domain and start completely
> from scratch, with two isolated development teams: one writing the
> specs and the other one doing the development separately. Most of you
> probably know this method from [5].

As I understand, the reverse engineering team should be able to use the
existing sources.  But the new coding team should not.  What matters is
that the new code is not derived from any proprietary code, but only
from the specification.

> I must say I find this the cleanest solution from an engineering and
> legal point of view, but I cannot help but feeling a bit unoptimistic
> about this taking off with the acx driver. There is not much of a
> community left, and all the people currently involved, although not
> many, would also have to leave the project, as they would have been
> "tainted" with the old sources.

That would be the reverse engineering team.  But you'll need to find a
"virgin" coder :-)

-- 
Regards,
Pavel Roskin
