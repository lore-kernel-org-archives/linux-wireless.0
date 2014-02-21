Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36136 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaBUIz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 03:55:57 -0500
Message-ID: <1392972954.4346.40.camel@jlt4.sipsolutions.net> (sfid-20140221_095600_818301_F93D10EA)
Subject: Re: [PATCH 1/2] cfg80211: regulatory, reset regdomain in case of
 error
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	linville@tuxdriver.com
Date: Fri, 21 Feb 2014 09:55:54 +0100
In-Reply-To: <1392364441-4640-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140214_085421_486369_23CAC419)
References: <1392364441-4640-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140214_085421_486369_23CAC419)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-02-14 at 08:54 +0100, Janusz Dziedzic wrote:
> Reset regdomain to world regdomain in case
> of errors in set_regdom() function.

Luis, please comment?

johannes

