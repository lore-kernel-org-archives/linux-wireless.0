Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44387 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab2AMTbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 14:31:09 -0500
Date: Fri, 13 Jan 2012 14:20:01 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] b43: add default option to avoid duplicating device
 support with brcmsmac
Message-ID: <20120113192000.GD18899@tuxdriver.com> (sfid-20120113_203113_746369_6860B247)
References: <1326315180-29398-1-git-send-email-linville@tuxdriver.com>
 <CACna6rxffpPhYVqKNttu79JET=NkBP4NrAayywQHWcj=mw=T9A@mail.gmail.com>
 <20120112161720.GI11093@tuxdriver.com>
 <20120113013248.30123.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120113013248.30123.qmail@stuge.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 13, 2012 at 02:32:48AM +0100, Peter Stuge wrote:
> John W. Linville wrote:
> > The summary line could be different as well, if you can think of a
> > better way to describe the issue.  I am open to suggestions.
> 
> I think these terms are clear:
> 
> Community b43 driver
> Broadcom brcmsmac driver
> 
> How to apply them I leave up to you. :)

Maybe you think that is clear, but it doesn't do much for me.

I could say "Support for devices already supported by the
Broadcom-supported brcmsmac driver"?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
