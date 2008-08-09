Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bromo.msbb.uc.edu ([129.137.3.146]:32887 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751651AbYHIAlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2008 20:41:51 -0400
Date: Fri, 8 Aug 2008 20:41:49 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: N protocol on 802.11a freq signal strength
Message-ID: <20080809004149.GA32305@bromo.msbb.uc.edu> (sfid-20080809_024154_387390_EE772C05)
References: <20080808141616.GA26224@bromo.msbb.uc.edu> <43e72e890808080949l1ee7a392m784fe06a3611e9ba@mail.gmail.com> <20080808173311.GA29952@bromo.msbb.uc.edu> <43e72e890808081045u70a98b28x10baef11379a0ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890808081045u70a98b28x10baef11379a0ba@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis,
    Do these numbers make sense? I find that under Fedora 9
with the Linux 2.6.27-rc2-git3 kernel (the first with the
ath9k drivers), I get...

TX-Power 23 dBn
Link Quality 25/100
Signal Level -82 dBm
Noise Level -95 dBm

This compares to under Mac OS X 10.5 which reports an RSSI of -66
at the same location.
                 Jack
