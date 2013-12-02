Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39081 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab3LBOjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 09:39:44 -0500
Message-ID: <1385995176.20277.0.camel@jlt4.sipsolutions.net> (sfid-20131202_153955_753669_2D5CE4A8)
Subject: Re: [PATCH 2/2] mac80211: Update opmode during adding new station
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Kwaczynski <marek.kwaczynski@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 02 Dec 2013 15:39:36 +0100
In-Reply-To: <1385994534-13383-2-git-send-email-marek.kwaczynski@tieto.com> (sfid-20131202_152938_476020_C588DC36)
References: <1385994534-13383-1-git-send-email-marek.kwaczynski@tieto.com>
	 <1385994534-13383-2-git-send-email-marek.kwaczynski@tieto.com>
	 (sfid-20131202_152938_476020_C588DC36)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-02 at 15:28 +0100, Marek Kwaczynski wrote:
> Update Operating mode is needed when User Space received Assoc
> Request contains Operating mode notification element.

Please fix coding style.

johannes

