Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from home.einfach.org ([80.86.92.145]:45190 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab0CIAfQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 19:35:16 -0500
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: fix I/Q calibration (for real)
Date: Tue, 9 Mar 2010 09:34:59 +0900
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
References: <20100308025841.7460.69949.stgit@void> <201003081317.25155.br1@einfach.org> <43e72e891003080824l74ecd4fbrf5a02e51c275c9b1@mail.gmail.com>
In-Reply-To: <43e72e891003080824l74ecd4fbrf5a02e51c275c9b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201003090934.59740.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 09 March 2010 01:24:48 Luis R. Rodriguez wrote:
> >> Thanks Bruno, are these stable fixes?
> > 
> > hi luis!
> > 
> > i think so. the behaviour before was completely broken, now it's better.
> > 
> > but i'm not sure about that whole Cc: stable@kernel.org thing... (sorry
> > i've been away for a while)... i read
> > Documentation/stable_kernel_rules.txt but still not sure if that applies
> > for this patch.
> 
> Just add:
> 
> Cc: stable@kernel.org
> 
> below your Singed-off-by on the commit log entry. That list will get
> spammed once the patch is merged on Linus' tree.

i understand that.

the question is more if my patch justifies bothering 'stable' or not.

as i said, in my point of view ath5k has several problems right now 
(performace and stability), and i guess nobody will be using it seriously in 
actual production use (does anyone?). so i think it does not really matter if 
this or any of my other patches go into stable sooner or later. does it?

bruno
