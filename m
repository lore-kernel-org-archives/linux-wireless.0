Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:51923 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbYKCRUp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 12:20:45 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1033418nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2008 09:20:44 -0800 (PST)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [GIT PATCH] rfkill fixes for 2.6.28-rc3
Date: Mon, 3 Nov 2008 18:20:40 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>
References: <1225730537-2679-1-git-send-email-hmh@hmh.eng.br> <200811031747.16326.IvDoorn@gmail.com> <20081103170243.GB2417@khazad-dum.debian.net>
In-Reply-To: <20081103170243.GB2417@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811031820.41165.IvDoorn@gmail.com> (sfid-20081103_182048_107690_06C085D2)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 03 November 2008, Henrique de Moraes Holschuh wrote:
> On Mon, 03 Nov 2008, Ivo van Doorn wrote:
> > On Monday 03 November 2008, Henrique de Moraes Holschuh wrote:
> > > This small patchset contains two fixes to issues in the suspend/resume
> > > handling of the rfkill class core.
> > > 
> > > It needs to go to 2.6.28.  These patches are based on 2.6.28-rc3.
> > 
> > Are they real regressions or normal bugfixes?
> 
> I am not sure if they regress anything, but I am pretty sure there is no
> bugzilla entry about them yet.  I have added two more interested parties to
> the CC.
> 
> So, if there is a strong feeling this would best be held until the next
> merge window, I can certainly respin the patches to on top of
> wireless-testing...

Well I'll give my ACK to the 2 patches, but I'll let john decide if they
are "regression" enough for 2.6.28. ;)

Ivo
