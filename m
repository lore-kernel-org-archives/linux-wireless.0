Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60971 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab0GVTAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 15:00:13 -0400
Date: Thu, 22 Jul 2010 14:56:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [PATCH] wireless: remove prism54
Message-ID: <20100722185616.GC2616@tuxdriver.com>
References: <1279735518-12515-1-git-send-email-linville@tuxdriver.com>
 <AANLkTikWo6tjyYCDMgoA9WXvbNaWIe_oSp180jcdtWgy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTikWo6tjyYCDMgoA9WXvbNaWIe_oSp180jcdtWgy@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 21, 2010 at 01:58:40PM -0700, Luis R. Rodriguez wrote:
> On Wed, Jul 21, 2010 at 11:05 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > This driver is no longer necessary due to p54pci.  It has seen very
> > little maintenance for some time, and at least Fedora has had it
> > disabled without any user complaints.
> >
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> Hm, we had a few users report back that only with prism54 and not
> p54pci could they get their device functional. IIRC Christian noted
> some issues with the EEPROM, and it seems the fault was on the
> manufacturer. My memory may be foggy but indeed I do remember a few
> users did complain about the feature removal plan. I can dig these
> e-mails up if needed.

I think I found some of that in the archive.  Do we have any sort of
plan for resolving these EEPROM-related (i.e. missing and/or damaged
EEPROM) issue?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
