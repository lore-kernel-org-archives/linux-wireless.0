Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lunatiki.de ([85.214.70.22]:40566 "EHLO
	h1112006.serverkompetenz.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368AbYBQVh5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 16:37:57 -0500
From: Patrick Grimm <patrick@lunatiki.de>
To: Richard Scherping <richard@scherping.de>
Subject: Re: [HOTFIX] Re: mac80211/iwl4965: ad-hoc broken in 2.6.25-rc1
Date: Sun, 17 Feb 2008 22:37:57 +0100
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
References: <47B1F422.4060501@scherping.de> <47B60044.9000801@scherping.de> <200802160119.07856.patrick@lunatiki.de>
In-Reply-To: <200802160119.07856.patrick@lunatiki.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802172237.57638.patrick@lunatiki.de> (sfid-20080217_213801_174924_D4C21EAC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 16. Februar 2008 01:19:07 schrieb Patrick Grimm:
> Am Freitag, 15. Februar 2008 22:12:36 schrieb Richard Scherping:
> > Chatre, Reinette schrieb:
> > >>> One more question ... did ad-hoc work for you before this patch?
> > >>
> > >> No. In my tests only ipw3945 works in Ad-Hoc mode.
> > >
> > > ok - that explains things. The patch assumes that ad-hoc mode is
> > > working, which is unfortunately not the case. We have to fix this.
> > >
> > > Reinette
> >
> > As I said, I have tested with iwl4965 only. Seems as if there are more
> > problems with ad-hoc and iwl3945. Did ad-hoc work in the "old" iwl3945
> > (before the API change with old version 1.1.17, compared to new version
> > 1.2.23/26)?
>
> I have made some short tests with my working kernel 2.6.23.
With 2 Ad-Hoc Nodes.
> Version 1.1.17 - 1.1.22 Ad-Hoc mode is working.
> Version 1.1.23 -            Ad-Hoc mode is not working.

The iwlwifi versions 1.1.17 - everything is not working
with more then 2 Ad-Hoc Nodes.

Please keep me updated I will test your patches again.

Patrick
