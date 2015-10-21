Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53967 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517AbbJUM15 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 08:27:57 -0400
Message-ID: <1445430474.4558.35.camel@sipsolutions.net> (sfid-20151021_142803_942168_2BE097B6)
Subject: Re: [PATCH] iw: Print help text to "set bitrates" in case of no args
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Ola Olsson <ola.olsson@sonymobile.com>
Date: Wed, 21 Oct 2015 14:27:54 +0200
In-Reply-To: <1445429499-22075-1-git-send-email-ola1olsson@gmail.com> (sfid-20151021_141147_510025_0355ABF4)
References: <1445429499-22075-1-git-send-email-ola1olsson@gmail.com>
	 (sfid-20151021_141147_510025_0355ABF4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is incorrect - the help states:

"Not passing any arguments would clear the existing mask (if any)."

johannes
