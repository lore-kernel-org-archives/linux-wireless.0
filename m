Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36938 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab0LGVAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 16:00:12 -0500
Date: Tue, 7 Dec 2010 15:57:14 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Javier Cardona <javier@cozybit.com>
Cc: Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: ath5k: Fixes for mesh operation
Message-ID: <20101207205713.GI2700@tuxdriver.com>
References: <1291169919-3867-1-git-send-email-javier@cozybit.com>
 <AANLkTik5bGXyWsz0CeVemZ-s9uWC+SOyJNzfxr1vcoGt@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTik5bGXyWsz0CeVemZ-s9uWC+SOyJNzfxr1vcoGt@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Waiting on davem to process my last pull request...

On Tue, Dec 07, 2010 at 11:12:55AM -0800, Javier Cardona wrote:
> John,
> 
> Are you waiting for acks from ath5k maintainers to apply this series?
> 
> https://patchwork.kernel.org/patch/369461/
> https://patchwork.kernel.org/patch/369471/
> https://patchwork.kernel.org/patch/369481/
> 
> Thanks!
> 
> Javier
> 
> On Tue, Nov 30, 2010 at 6:18 PM, Javier Cardona <javier@cozybit.com> wrote:
> > After applying these fixes we were able to successfully bring up mesh
> > interfaces and establish peer links with ath9k devices.
> >
> > One issue still looms with both athX drivers:  you have to issue a scan to get
> > mesh beaconing started.  Keep that in mind if you try and test these fixes.
> >
> >
> 
> 
> 
> -- 
> Javier Cardona
> cozybit Inc.
> http://www.cozybit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
