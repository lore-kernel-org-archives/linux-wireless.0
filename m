Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2931 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZKGR0n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 12:26:43 -0500
Date: Sat, 7 Nov 2009 12:26:14 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: =?iso-8859-1?Q?Mart=EDn?= Ernesto Barreyro
	<barreyromartin@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Changing from Minstrel to PID
Message-ID: <20091107172614.GB20330@hash.localnet>
References: <1257542956.6565.2.camel@localhost.localdomain> <20091106214803.GL2782@tuxdriver.com> <1257545606.3752.2.camel@localhost.localdomain> <b6c5339f0911061424l33178e81k16fb1f3889edcc3c@mail.gmail.com> <20091107134330.GB25893@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091107134330.GB25893@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 07, 2009 at 08:43:30AM -0500, John W. Linville wrote:
> > echo 'pid' > /debug/ieee80211/phy0/rc/name
> > 
> > to switch to pid.
> 
> Does that work?  I thought that was only informational (and readonly)?

Oh, yes, you are right.  I was thinking of the ieee80211_default_rc_algo
modparam for mac80211.

-- 
Bob Copeland %% www.bobcopeland.com

