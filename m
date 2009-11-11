Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:62970 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758231AbZKKRcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 12:32:02 -0500
Received: by iwn8 with SMTP id 8so1085963iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 11 Nov 2009 09:32:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <154E55ADF9629D4E8D13F08BF92ABEB63FDC98336B@PDSMSX501.ccr.corp.intel.com>
References: <154E55ADF9629D4E8D13F08BF92ABEB63FDC983366@PDSMSX501.ccr.corp.intel.com>
	<20091111152214.GG4392@tuxdriver.com> <154E55ADF9629D4E8D13F08BF92ABEB63FDC98336B@PDSMSX501.ccr.corp.intel.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 11 Nov 2009 09:31:48 -0800
Message-ID: <43e72e890911110931l893b90dta2d5806d10189925@mail.gmail.com>
Subject: Re: [ANNOUNCE] wifi-test 1.0 released
To: "Zheng, Jeff" <jeff.zheng@intel.com>,
	wifi-test-devel@lists.sourceforge.net
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/11/11 Zheng, Jeff <jeff.zheng@intel.com>:
> Thanks.
>
> And also thanks Reinette and Johannes's help.

Thank you guys so much for this, I just reviewed it and it seems you
do need some AP with remote login, a bit overkill for end users but I
hope it'll prove valuable for our own testing as well.

Are you interested in receiving patches for simple end user tests
against an AP with no login?

BTW I've created a wiki page for this here:

http://wireless.kernel.org/en/developers/Testing/wifi-test

Can we instead rely on a wiki instead of a static page that only a few
have access to?

 Luis
