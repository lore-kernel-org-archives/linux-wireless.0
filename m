Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f191.google.com ([209.85.216.191]:53804 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab0BTChV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 21:37:21 -0500
Received: by pxi29 with SMTP id 29so404187pxi.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2010 18:37:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266625309.25707.44.camel@mj>
References: <43e72e891002121810g25d21eb5y254969458a9a58e7@mail.gmail.com>
	<43e72e891002161323v70636defr2500784ffb44d775@mail.gmail.com>
	<1266358340.2659.37.camel@mj> <43e72e891002161459m4174654aj8d7985f32cb8678d@mail.gmail.com>
	<43e72e891002161645p627c123g9ac571e4802cd8bf@mail.gmail.com>
	<43e72e891002161651w4718431dqaf258151241f72fc@mail.gmail.com>
	<1266467017.3065.62.camel@mj> <1266473734.11805.5.camel@mj>
	<20100218183058.GG8069@bombadil.infradead.org> <1266625309.25707.44.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 19 Feb 2010 18:37:01 -0800
Message-ID: <43e72e891002191837o10ef84d6u9d0d3d61881a64fc@mail.gmail.com>
Subject: Re: compat-wireless + Linux 2.6.26.8 testing results
To: Pavel Roskin <proski@gnu.org>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 19, 2010 at 4:21 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Thu, 2010-02-18 at 13:30 -0500, Luis R. Rodriguez wrote:
>
>> Sweeet, thanks a lot! I've sucked this into all the respective git trees. This
>> means we now have backporting re-enabled on bleeding edge for kernels older
>> than 2.6.27 (whoopdi-free'kin-doo for those who are on those ancient kernels).
>
> debugfs_remove_recursive() was misplaced.  It should be in
> compat-2.6.27, as it appeared in Linux 2.6.27.  With that change,
> compat-wireless compiles for 2.6.26.8 for Gateworks Cambria boards :)

Neat!

> Thank you for your great work on compat-wireless!

Thanks for your patches :D

  Luis
