Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47025 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab1CGByT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 20:54:19 -0500
Received: by iwn34 with SMTP id 34so3535903iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 17:54:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110307012714.GA2465@tuxdriver.com>
References: <AANLkTimaVjAsW4g8kAfi=vQaPCabkj-ZO9vZw_Lex7KY@mail.gmail.com>
 <1299446809.5082.161.camel@wwguy-huron> <20110307012714.GA2465@tuxdriver.com>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Sun, 6 Mar 2011 17:53:58 -0800
Message-ID: <AANLkTikqbstjewp2U+oAd=371kEhD3MjAU70cqAon9BS@mail.gmail.com>
Subject: Re: [ipw3945-devel] can't compile iwlwifi latest wireless-testing
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 6, 2011 at 5:27 PM, John W. Linville <linville@tuxdriver.com> wrote:
> That seems a bit silly.  Does adding an include for sched.h to iwl-rx.c
> fix the build issue?

Yes, the linux/sched.h include succeeds.

> I wonder why this builds fine for me?  What arch fails to build?

I've got a regular x86 (32-bit) Ubuntu 10.04.1 LTS system running on
wireless-testing master-2011-03-04, and I get this error.  I've put my
.config, as well as the error message, up on gist:
https://gist.github.com/857960

Dan
