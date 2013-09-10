Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:57122 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab3IJION (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 04:14:13 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21038.54250.912310.332354@gargle.gargle.HOWL> (sfid-20130910_101418_208909_76C3E6D2)
Date: Tue, 10 Sep 2013 13:40:18 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap\@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: Re: Always send management frames at MCS-0??
In-Reply-To: <522E1D31.2090403@candelatech.com>
References: <522E1D31.2090403@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> I had a user request that we support always sending management frames
> (such as EAPOL) at the lowest rate.  Evidently, other equipment does this,
> where as normal-ish supplicant/linux tends to send them at much higher
> rates.
> 
> Any suggestions on how to go about doing this properly?

If this is with ath9k_rate_control, then it is a known bug:
https://bugzilla.redhat.com/show_bug.cgi?id=927191

Sujith
