Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27258 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab2GFBHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 21:07:43 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20470.14858.754361.629383@gargle.gargle.HOWL> (sfid-20120706_030800_928075_7C4C703A)
Date: Fri, 6 Jul 2012 06:36:18 +0530
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"Balasubramanian, Senthil Kumar" <senthilb@qca.qualcomm.com>,
	"Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
	qca-linux-team <qca-linux-team@qualcomm.com>,
	Imran Ansari <imran@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<sfr@canb.auug.org.au>, <mcgrof@frijolero.org>, <hauke@hauke-m.de>,
	<ozancag@gmail.com>, <pstew@google.com>, <warthog9@kernel.org>,
	<jrnieder@gmail.com>, <ben@decadent.org.uk>,
	<akpm@linux-foundation.org>, <gregkh@linuxfoundation.org>,
	<linville@tuxdriver.com>
Subject: Re: 3.5 stable compat-wireless
In-Reply-To: <20120705190801.GB11228@tux>
References: <20468.35601.132955.802881@gargle.gargle.HOWL>
	<7A9ADFFA56024346AAE90B6BABC3BD15DD6DEB@NASANEXD02B.na.qualcomm.com>
	<20469.13787.767293.602337@gargle.gargle.HOWL>
	<20120705190801.GB11228@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> > To make internal releases, I do something like this:
> > 
> > * Maintain a 'linux-foo-pending' branch, add pending patches and kick out releases
> >   for immediate testing.
> 
> A linux-foo-pending branch of linux-next.git ?

No, in compat-wireless - not in upstream, but in my 'forked' tree.
This is just to avoid the shuttling of patches between linux-next-pending/
and linux-next-cherry-picks/.

Sujith
