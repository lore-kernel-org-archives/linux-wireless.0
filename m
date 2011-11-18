Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab1KRPj3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 10:39:29 -0500
Date: Fri, 18 Nov 2011 16:41:33 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 28/77] iwlegacy: rename base 4965 and 3945 file names
Message-ID: <20111118154133.GD2203@redhat.com> (sfid-20111118_163933_224009_56935F87)
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
 <1321604559-10707-28-git-send-email-sgruszka@redhat.com>
 <1321626098.11647.13.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1321626098.11647.13.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 18, 2011 at 06:21:38AM -0800, Guy, Wey-Yi wrote:
> On Fri, 2011-11-18 at 00:21 -0800, Stanislaw Gruszka wrote:
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/iwlegacy/3945-mac.c     | 4007 ++++++++++++++++++++++++++
> >  drivers/net/wireless/iwlegacy/3945.c         | 2740 ++++++++++++++++++
> >  drivers/net/wireless/iwlegacy/4965-mac.c     | 3245 +++++++++++++++++++++
> >  drivers/net/wireless/iwlegacy/4965.c         | 2183 ++++++++++++++
> >  drivers/net/wireless/iwlegacy/Makefile       |    4 +-
> >  drivers/net/wireless/iwlegacy/iwl-3945.c     | 2740 ------------------
> >  drivers/net/wireless/iwlegacy/iwl-4965.c     | 2183 --------------
> >  drivers/net/wireless/iwlegacy/iwl3945-base.c | 4007 --------------------------
> >  drivers/net/wireless/iwlegacy/iwl4965-base.c | 3245 ---------------------
> >  9 files changed, 12177 insertions(+), 12177 deletions(-)
> >  create mode 100644 drivers/net/wireless/iwlegacy/3945-mac.c
> >  create mode 100644 drivers/net/wireless/iwlegacy/3945.c
> >  create mode 100644 drivers/net/wireless/iwlegacy/4965-mac.c
> >  create mode 100644 drivers/net/wireless/iwlegacy/4965.c
> >  delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945.c
> >  delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965.c
> >  delete mode 100644 drivers/net/wireless/iwlegacy/iwl3945-base.c
> >  delete mode 100644 drivers/net/wireless/iwlegacy/iwl4965-base.c
> > 
> > 683K patch can be downloaded from:
> > http://people.redhat.com/sgruszka/iwlegacy-2011-11-16/0028-iwlegacy-rename-base-4965-and-3945-file-names.patch
> > --
> myabe also rename other modules which has "iwl" prefix to "il"? such as
> iwl-led.c, iwl-eeprom.c, ...
Other patched do that.

Stanislaw
