Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:39385 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762963AbYBZVus (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 16:50:48 -0500
Date: Tue, 26 Feb 2008 22:38:14 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "Chris Clayton" <chris2553@googlemail.com>
Cc: linville@tuxdriver.com, ivdoorn@gmail.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Message-ID: <20080226223814.4ef2b435@morte> (sfid-20080226_215105_160737_95F90C1F)
In-Reply-To: <c6b1100b0802261313v12fb9cd5j6501e80f6d071019@mail.gmail.com>
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	<200802252104.32416.chris2553@googlemail.com>
	<a32f33a40802251409ofbdab60w4a95c8aaefaad70a@mail.gmail.com>
	<200802261911.39577.chris2553@googlemail.com>
	<20080226194838.GD3013@tuxdriver.com>
	<c6b1100b0802261313v12fb9cd5j6501e80f6d071019@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 26 Feb 2008 21:13:48 +0000
"Chris Clayton" <chris2553@googlemail.com> wrote:

> And I will help in any way I can, providing diagnostics and trying patches.

Please, could you mount debugfs and provide me with a dump of this file:
/debug/ieee80211/phy*/stations/*/rc_pid_events

Thank you.


--
Ciao
Stefano
