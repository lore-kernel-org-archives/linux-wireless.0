Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54731 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3AKXkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 18:40:13 -0500
Message-ID: <1357947638.9767.8.camel@jlt4.sipsolutions.net> (sfid-20130112_004018_135262_2E9B99BC)
Subject: Re: wireless-regdb updated, please check!
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 12 Jan 2013 00:40:38 +0100
In-Reply-To: <20130111193922.GD2170@tuxdriver.com> (sfid-20130111_204517_481009_5182122F)
References: <20130111193922.GD2170@tuxdriver.com>
	 (sfid-20130111_204517_481009_5182122F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-01-11 at 14:39 -0500, John W. Linville wrote:
> All,
> 
> I've been sitting on some wireless-regdb patches for some time.
> Mostly this is because I wasn't sure what to do with some/most of them.
> I even still have a few more like that...

Could you also apply "regdb: allow 40 MHz on world roaming channels
12/13" -- we've already applied the same change to the kernel's version
of the world roaming regdomain.

johannes

