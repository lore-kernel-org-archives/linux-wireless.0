Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44361 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1KWOpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 09:45:30 -0500
Date: Wed, 23 Nov 2011 09:34:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: Timo Lindhorst <tlnd@online.de>, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: Fix changing regulatory from userspace
Message-ID: <20111123143456.GB2502@tuxdriver.com> (sfid-20111123_154535_224466_A776240F)
References: <201111230330.11103.tlnd@online.de>
 <CAB=NE6U6ru-xns8M+YUccqxw0FwE-sWtZnFkPUud3jHdAcDxsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6U6ru-xns8M+YUccqxw0FwE-sWtZnFkPUud3jHdAcDxsw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 23, 2011 at 06:28:57AM -0800, Luis R. Rodriguez wrote:
> On Tue, Nov 22, 2011 at 6:30 PM, Timo Lindhorst <tlnd@online.de> wrote:
> > The commit de3584bd62d87b4c250129fbc46ca52c80330add -
> > "cfg80211: fix regulatory NULL dereference" prevents the regulatory
> > domain from being changed by user space. A wiphy is only present
> > if the request comes from driver or is set by country IE, thus
> > check only those cases.
> >
> > Signed-off-by: Timo Lindhorst <tlnd@online.de>
> 
> Yup but at this point I'd prefer we revert the original patch instead
> given that the patch also had some other short comings. John is it too
> late?

No, it isn't too late to revert it.  But can we have a new fix soon?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
