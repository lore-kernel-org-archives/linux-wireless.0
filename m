Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:38218 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192Ab1AKQ7Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 11:59:25 -0500
Subject: Re: wl12xx compat wireless rcu_read_lock issue
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTi=4H6TXvXWi_KVBEn3G_aNW_8qZfBF7g36WRED6@mail.gmail.com>
References: <1294062164-3459-1-git-send-email-shahar_levi@ti.com>
	 <1294062164-3459-2-git-send-email-shahar_levi@ti.com>
	 <1294671655.1992.103.camel@pimenta>
	 <AANLkTi=KnSjVVCN=9=PaL9_GYpDOpJFvD-LGxFXEevhw@mail.gmail.com>
	 <AANLkTimpDo=0AcL5OdEjnpB8-_o7XBJ5QT-mE-FmfZo6@mail.gmail.com>
	 <13872098A06B02418CF379A158C0F146015BEB592B@dnce02.ent.ti.com>
	 <1294745300.12992.90.camel@pimenta>
	 <AANLkTi=4H6TXvXWi_KVBEn3G_aNW_8qZfBF7g36WRED6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 18:59:35 +0200
Message-ID: <1294765175.1981.4.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-11 at 17:03 +0100, Arik Nemtsov wrote:
> On Tue, Jan 11, 2011 at 13:28, Luciano Coelho <coelho@ti.com> wrote:
> > I hadn't seen it before, but then again, I just integrated the AP
> > patches which added this code.  The code has been tested quite well
> > before, but indeed this is broken.

[...]

> Actually this change is part of the HT patch series (in patch
> 18357850b694ba3fa29363c7d86ccd8783f4a065) so it was there quite some
> time.
> But I did port over without noticing the bug :)

Right, I didn't check very carefully when the bug was introduced and it
doesn't matter much anyway.  But it's a bug and needs to be fixed.  Does
any volunteers to send a patch or should I do it myself? (feeling
lazy :P)


-- 
Cheers,
Luca.

