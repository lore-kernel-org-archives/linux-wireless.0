Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3959 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab0ETWxP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 18:53:15 -0400
Date: Thu, 20 May 2010 18:46:09 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Jaroslav Fojtik <jafojtik@seznam.cz>,
	linux-wireless@vger.kernel.org
Subject: Re: How to scan APs with ATH5k?
Message-ID: <20100520224609.GA27842@hash.localnet>
References: <1274296671-13596-1-git-send-email-gwingerde@gmail.com> <4BF4CFE8.10182.FA668@jafojtik.seznam.cz> <AANLkTim90zZxvcwT9joVAqO1oDzk-jCaRCQAd0Cfu3N0@mail.gmail.com> <4BF58D72.22852.D1D2D@jafojtik.seznam.cz> <1274392411.7054.6.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1274392411.7054.6.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 20, 2010 at 05:53:31PM -0400, Pavel Roskin wrote:
> On Thu, 2010-05-20 at 21:28 +0200, Jaroslav Fojtik wrote:
> It looks like a bug.  Even if something is preventing scanning, the
> error code should be -EBUSY (device busy).
> 
> The same is true for ath9k, but I cannot test ath5k at the moment.
> mac80211 does a considerable effort to allow scanning while associated.

It's certainly something that used to work, but I haven't tried in
a recent kernel.  So yes probably a bug.
-- 
Bob Copeland %% www.bobcopeland.com

