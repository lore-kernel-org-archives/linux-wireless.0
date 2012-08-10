Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40962 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab2HJTu0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 15:50:26 -0400
Received: by obbuo13 with SMTP id uo13so2683694obb.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2012 12:50:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHashqAQ9tD3qmzMRNfzLcGbD2A9gykFjUbOhqZA=uLJBnQ4Gw@mail.gmail.com>
References: <2121451356.93690.1344518764022.JavaMail.root@neratec.com>
 <5025425A.2090207@hauke-m.de> <CAHashqAQ9tD3qmzMRNfzLcGbD2A9gykFjUbOhqZA=uLJBnQ4Gw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Fri, 10 Aug 2012 12:50:05 -0700
Message-ID: <CAB=NE6VT+dxeN=BhWJrz+iS8GjS7o+phDJHRhuF2jRL_EEiGVA@mail.gmail.com> (sfid-20120810_215030_316434_B11B8512)
Subject: Re: [PATCH v2] compat: support RHEL6.3 as a build target
To: Andy Gospodarek <andy@greyhouse.net>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Phil Perry <phil@elrepo.org>,
	lf driver backport
	<lf_driver_backport@lists.linux-foundation.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 10, 2012 at 11:28 AM, Andy Gospodarek <andy@greyhouse.net> wrote:
> Did you try the patch I posted last night that has the updated define
> for no_printk()?  I saw the same error until I applied that patch.

Andy, can you post a new patch on a new thread that is rebased on top
of the latest compat.git master and without putting stuff above the
patch ?

  Luis
