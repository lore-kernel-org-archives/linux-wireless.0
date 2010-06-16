Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60613 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758330Ab0FPNpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 09:45:10 -0400
Date: Wed, 16 Jun 2010 09:44:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kouhei Sutou <kou@clear-code.com>
Cc: mcgrof@gmail.com, Stephen.Chen@atheros.com, David.Quan@atheros.com,
	linux-wireless@vger.kernel.org, Michael.Green@atheros.com
Subject: Re: [PATCH] zd1211rw: ignore unknown regulatory domain.
Message-ID: <20100616134421.GB2404@tuxdriver.com>
References: <AANLkTinEMAQu33Tlv81-Cdx9fLZK-a-7uJlbAo7te2_w@mail.gmail.com>
 <20100615.232558.867740727379709943.kou@clear-code.com>
 <AANLkTin9bG4qDEKwgOXmlR3k9wZ-JBSIlh3JzYjzVDeY@mail.gmail.com>
 <20100616.215523.1718341995174283889.kou@clear-code.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100616.215523.1718341995174283889.kou@clear-code.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 16, 2010 at 09:55:23PM +0900, Kouhei Sutou wrote:

> I used 'ZD_REGDOMAIN_JAPAN_GW_US54GXS' as a macro name for
> 0x49 because 0x49 is used by GW-US54GXS. Is it OK? Or should
> I use other name for it?

Hopefully someone can suggest a better name.  Anyone know what inspired
"ZD_REGDOMAIN_JAPAN_ADD"?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
