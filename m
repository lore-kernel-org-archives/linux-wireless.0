Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:59966 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbXJWI4t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 04:56:49 -0400
Received: by py-out-1112.google.com with SMTP id u77so3009926pyb
        for <linux-wireless@vger.kernel.org>; Tue, 23 Oct 2007 01:56:48 -0700 (PDT)
Message-ID: <f6ca9fed0710230156g6b19f6fbu24e3b9ea40c1b433@mail.gmail.com> (sfid-20071023_095655_863003_1DBAB136)
Date: Tue, 23 Oct 2007 10:56:48 +0200
From: dragoran <drago01@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [ipw3945-devel] iwl3945/mac80211 cannot connect to dynamic wep network
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Volker Braun" <volker.braun@physik.hu-berlin.de>
In-Reply-To: <1193127280.3069.261.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0710230054i2b2849bfpc79c6090627b8625@mail.gmail.com>
	 <1193127280.3069.261.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/23/07, Zhu Yi <yi.zhu@intel.com> wrote:
>
> On Tue, 2007-10-23 at 09:54 +0200, dragoran wrote:
> > I really have bo idea what this means... with ipw3945 (ieee80211
> > based) the same network works just fine.
>
> This is related to mac80211, not the driver. That's why ipw3945 works.
> Does this patch work for you?
>
> http://marc.info/?l=linux-wireless&m=118715117523167&w=2

I thought this was already merged. Will build a new kernel with it and
test again tomorrow.
