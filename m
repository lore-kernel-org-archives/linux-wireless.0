Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:43733 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab2BIPnS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 10:43:18 -0500
Date: Thu, 9 Feb 2012 10:43:13 -0500
From: Pavel Roskin <proski@gnu.org>
To: lina <lina.lastname@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: something about compact-wireless
Message-ID: <20120209104313.19c8bf18@mj> (sfid-20120209_164322_192867_ABCB660E)
In-Reply-To: <CAG9cJm=CM+2tQ1ChQb+Vx5aAyoH4RjL5SbRuai_CmFsiPJXFVQ@mail.gmail.com>
References: <CAG9cJmnuyjxLFe5Wc4okDmOw4ik0aC_vT8xi5rEhfUJGbiczcg@mail.gmail.com>
	<4F32BB6E.1020803@lwfinger.net>
	<CAG9cJmmffGJBpefd5uz6DP=kjdxPPU7K6hrt0SF81hTL04hLCw@mail.gmail.com>
	<4F332B69.6090009@gmail.com>
	<CAG9cJm=CM+2tQ1ChQb+Vx5aAyoH4RjL5SbRuai_CmFsiPJXFVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 9 Feb 2012 11:06:28 +0800
lina <lina.lastname@gmail.com> wrote:

> On Thu, Feb 9, 2012 at 10:11 AM, Richard Farina <sidhayn@gmail.com>
> wrote:
> > if you don't know if you need compat-wireless then you don't need
> > compat-wireless.
> 
> But I have installed the compat-wireless.

Please stop this public self-humiliation.

> during kernel compilation it showed me:
> 
> :/var/lib/dkms/blcr/0.8.2/build# more make.log
> DKMS make.log for blcr-0.8.2 for kernel 3.2.5mj-lina (x86_64)
> Thu Feb  9 00:35:52 SGT 2012
> make: Entering directory `/scratch/staff/linux-source-3.2.5'
> /var/lib/dkms/blcr/0.8.2/build/Kbuild:19: /var/lib/dkms/blcr/0.8.2/build/module

It's not even a part on the standard kernel.  And it's not about
wireless networking.  And there is no evidence that compat-wireless has
anything to do with it.

Please read this document:
http://catb.org/esr/faqs/smart-questions.html

Please pay special attention to the following parts:
http://catb.org/esr/faqs/smart-questions.html#beprecise
http://catb.org/esr/faqs/smart-questions.html#goal
http://catb.org/esr/faqs/smart-questions.html#explicit

-- 
Regards,
Pavel Roskin
