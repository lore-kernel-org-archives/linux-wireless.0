Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:54318 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab0BTAWO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 19:22:14 -0500
Subject: Re: compat-wireless + Linux 2.6.26.8 testing results
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20100218183058.GG8069@bombadil.infradead.org>
References: <43e72e891002121810g25d21eb5y254969458a9a58e7@mail.gmail.com>
	 <1266124222.13902.42.camel@mj>
	 <43e72e891002161323v70636defr2500784ffb44d775@mail.gmail.com>
	 <1266358340.2659.37.camel@mj>
	 <43e72e891002161459m4174654aj8d7985f32cb8678d@mail.gmail.com>
	 <43e72e891002161645p627c123g9ac571e4802cd8bf@mail.gmail.com>
	 <43e72e891002161651w4718431dqaf258151241f72fc@mail.gmail.com>
	 <1266467017.3065.62.camel@mj> <1266473734.11805.5.camel@mj>
	 <20100218183058.GG8069@bombadil.infradead.org>
Content-Type: text/plain
Date: Fri, 19 Feb 2010 19:21:49 -0500
Message-Id: <1266625309.25707.44.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-02-18 at 13:30 -0500, Luis R. Rodriguez wrote:

> Sweeet, thanks a lot! I've sucked this into all the respective git trees. This
> means we now have backporting re-enabled on bleeding edge for kernels older
> than 2.6.27 (whoopdi-free'kin-doo for those who are on those ancient kernels).

debugfs_remove_recursive() was misplaced.  It should be in
compat-2.6.27, as it appeared in Linux 2.6.27.  With that change,
compat-wireless compiles for 2.6.26.8 for Gateworks Cambria boards :)

Thank you for your great work on compat-wireless!

-- 
Regards,
Pavel Roskin
