Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:46777 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaDSAtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2014 20:49:08 -0400
Date: Sat, 19 Apr 2014 10:48:49 +1000
From: James Cameron <quozl@laptop.org>
To: John Tobias <john.tobias.ph@gmail.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 2/2] mwifiex: don't clear cmd_sent flag in timeout handler
Message-ID: <20140419004849.GC14606@us.netrek.org> (sfid-20140419_024934_632797_5F2861B2)
References: <1397710914-10061-1-git-send-email-bzhao@marvell.com>
 <1397710914-10061-2-git-send-email-bzhao@marvell.com>
 <CACUGKYMWqr2-YAXhPzo8GfPPYBd2xoD_zf56FzqpkzN=X80X8A@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F70430F70686650@SC-VEXCH1.marvell.com>
 <20140418044619.GF24166@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F706868D4@SC-VEXCH1.marvell.com>
 <20140419003410.GB14606@us.netrek.org>
 <CACUGKYOPSnxWohpXL_FTs2Gyf9VKdLChkdqYx2hmApR+cTVcMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACUGKYOPSnxWohpXL_FTs2Gyf9VKdLChkdqYx2hmApR+cTVcMw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 18, 2014 at 05:42:57PM -0700, John Tobias wrote:
> May I know what processor are you using?.

Sure.

OLPC XO-4 laptop, with Marvell PXA2128 system on a chip.

The arm-3.5 branch at git://dev.laptop.org/git/olpc-kernel/

-- 
James Cameron
http://quozl.linux.org.au/
