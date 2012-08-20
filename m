Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36116 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab2HTKeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 06:34:04 -0400
Message-ID: <1345458836.4459.2.camel@jlt3.sipsolutions.net> (sfid-20120820_123408_212148_EF780C3A)
Subject: Re: [PATCH] Revert "rfkill: remove dead code"
From: Johannes Berg <johannes@sipsolutions.net>
To: AceLan Kao <acelan.kao@canonical.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org,
	Corentin Chary <corentincj@iksaif.net>,
	Matthew Garrett <mjg59@srcf.ucam.org>
Date: Mon, 20 Aug 2012 12:33:56 +0200
In-Reply-To: <CAMz9Wg8DdBbWXUv5gQKr6TJmxQqXHn_DEA4UyyuNPzNwsa4Deg@mail.gmail.com> (sfid-20120820_041144_435039_23A24BE0)
References: <1343267468-9986-1-git-send-email-acelan.kao@canonical.com>
	 <CAGRGNgWk1wV_6Xi6jQppkBtJ+1TYRpTSQ=v8NZffqSBtJNGBYQ@mail.gmail.com>
	 <CAMz9Wg8a0rAj8FN4gczfB6aUA8KgAiTc0_MG6Vc046Zmo4o0Tw@mail.gmail.com>
	 <CAGRGNgX+QmoYhkPuPrr_c5TvqRP=hhzxOSftZh969aOFeiV28g@mail.gmail.com>
	 <CAMz9Wg8eMTJcmd5tcxBURP3Rmuu4siEFTBDqW1aK8rqdZ8utqA@mail.gmail.com>
	 <20120813184749.GC10529@tuxdriver.com>
	 <CAMz9Wg-Ft-STtew-zZ9wSbiC79iEpyV3vp1HoiCutEvn1g=-MA@mail.gmail.com>
	 <CAMz9Wg8DdBbWXUv5gQKr6TJmxQqXHn_DEA4UyyuNPzNwsa4Deg@mail.gmail.com>
	 (sfid-20120820_041144_435039_23A24BE0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-08-20 at 10:11 +0800, AceLan Kao wrote:
> Hi,
> 
> I didn't see this patch in linux-next nor in Linville's tree,and this
> patch is needed by the asus-wmi driver.
> Please help to merge this patch earlier, so that platform-x86 can get
> rid of the compiling error.
> Thank you very much.

I have no objections to this -- should I pick it up, John?

johannes

