Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:21406 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbYFKUuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 16:50:05 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3267266wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 13:50:05 -0700 (PDT)
Message-ID: <69e28c910806111350x7e233437x57983a9b27116bc0@mail.gmail.com> (sfid-20080611_225025_059062_52380F8C)
Date: Wed, 11 Jun 2008 22:50:05 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [compat-masters] Backported MQ requirement on 802.11n for older kernels
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	compat-masters@lists.madwifi.org,
	"Tim Gardner" <tim.gardner@canonical.com>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240806110627g467940b1k9ca4a43cd140506f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <43e72e890806080855p284f85brd0ff1f1dfce96bf8@mail.gmail.com>
	 <43e72e890806090201q55bff8e3m694121ebd4befee6@mail.gmail.com>
	 <43e72e890806090325y5a1aebadq68204695044f4b6f@mail.gmail.com>
	 <1ba2fa240806101657w14599f30x67f58acbc7fe9e80@mail.gmail.com>
	 <43e72e890806102132q1aaba42ehd76bdd30b8d4080a@mail.gmail.com>
	 <43e72e890806102136jb8e695fla98a8594dde14396@mail.gmail.com>
	 <43e72e890806110403nddfca7cn66b91a938919e1f0@mail.gmail.com>
	 <7ba851519c84785f96af3637e9bab65b.squirrel@secure.sipsolutions.net>
	 <20080611125857.GG17936@ruslug.rutgers.edu>
	 <1ba2fa240806110627g467940b1k9ca4a43cd140506f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2008 at 3:27 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> The makefile is feed by compat.mk and DOTconfig from the target kernel
> (KLIB) (in my case 2.6.25)
> From what I see the flags from wireless-testing  need to be always
> reflected in compat.mk.

Did you mean config.mk? Compat.mk doesn't exist.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
