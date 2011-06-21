Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:41916 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756977Ab1FURnv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 13:43:51 -0400
Received: from [195.4.92.23] (helo=13.mx.freenet.de)
	by mout2.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #5)
	id 1QZ4zN-00076T-D6
	for linux-wireless@vger.kernel.org; Tue, 21 Jun 2011 19:43:49 +0200
Received: from p54a1944b.dip0.t-ipconnect.de ([84.161.148.75]:34582 helo=mail.maya.org)
	by 13.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #5)
	id 1QZ4zM-0006Hs-U0
	for linux-wireless@vger.kernel.org; Tue, 21 Jun 2011 19:43:49 +0200
Message-ID: <4E00D879.1060005@01019freenet.de> (sfid-20110621_194354_458460_04ED719F)
Date: Tue, 21 Jun 2011 19:44:25 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Yogesh Ashok Powar <yogeshp@marvell.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom reservation
References: <20110617132527.GA27436@hertz.marvell.com> <1308331485.7329.2.camel@Nokia-N900-51-1> <20110620143051.GA31035@hertz.marvell.com> <1308583799.4322.9.camel@jlt3.sipsolutions.net> <7DDF37406E10F0438561DBB78326DF3902F5D190E2@SC-VEXCH1.marvell.com> <1308590980.4322.19.camel@jlt3.sipsolutions.net> <20110621130305.GB32464@hertz.marvell.com> <1308663814.4276.3.camel@jlt3.sipsolutions.net> <20110621141017.GC32464@hertz.marvell.com> <1308667215.4276.7.camel@jlt3.sipsolutions.net> <20110621163351.GD32464@hertz.marvell.com>
In-Reply-To: <20110621163351.GD32464@hertz.marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'll test the patch as far as it is ready :-). Could you please create a
complete patch, which runs against a clean compat-wireless-3.0-rc1-1 (or
compat-wireless-2011-06-15)? And maybe, for testing purpose, a log
entry, which makes it possible to check, whether the code is really used
(if it doesn't flood messages)?


Thanks,
Andreas
