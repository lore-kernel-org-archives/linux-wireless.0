Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51990 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757914Ab0FPPaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 11:30:11 -0400
Date: Wed, 16 Jun 2010 11:29:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kouhei Sutou <kou@clear-code.com>
Cc: mcgrof@gmail.com, Stephen.Chen@atheros.com, David.Quan@atheros.com,
	linux-wireless@vger.kernel.org, Michael.Green@atheros.com
Subject: Re: [PATCH] zd1211rw: ignore unknown regulatory domain.
Message-ID: <20100616152903.GA3138@tuxdriver.com>
References: <AANLkTin9bG4qDEKwgOXmlR3k9wZ-JBSIlh3JzYjzVDeY@mail.gmail.com>
 <20100616.215523.1718341995174283889.kou@clear-code.com>
 <20100616134421.GB2404@tuxdriver.com>
 <20100617.000223.656204364469558896.kou@clear-code.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100617.000223.656204364469558896.kou@clear-code.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 17, 2010 at 12:02:23AM +0900, Kouhei Sutou wrote:
> Hi,
> 
> In <20100616134421.GB2404@tuxdriver.com>
>   "Re: [PATCH] zd1211rw: ignore unknown regulatory domain." on Wed, 16 Jun 2010 09:44:22 -0400,
>   "John W. Linville" <linville@tuxdriver.com> wrote:
> 
> > On Wed, Jun 16, 2010 at 09:55:23PM +0900, Kouhei Sutou wrote:
> > 
> >> I used 'ZD_REGDOMAIN_JAPAN_GW_US54GXS' as a macro name for
> >> 0x49 because 0x49 is used by GW-US54GXS. Is it OK? Or should
> >> I use other name for it?
> > 
> > Hopefully someone can suggest a better name.  Anyone know what inspired
> > "ZD_REGDOMAIN_JAPAN_ADD"?
> 
> 'ZD_REGDOMAIN_JAPAN_3' was used in another patch:
>   https://patchwork.kernel.org/patch/47220/
> 
> But I don't know why '3' was used...

'3' makes sense to me.  The better question is why not change 'ADD' to '2'? :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
