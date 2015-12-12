Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42065 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbbLLSA4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2015 13:00:56 -0500
Message-ID: <1449943252.2259.4.camel@sipsolutions.net> (sfid-20151212_190127_715722_E649F937)
Subject: Re: [PATCH] ocb: remove unnecessary variable increments
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Ola Olsson <ola.olsson@sonymobile.com>
Date: Sat, 12 Dec 2015 19:00:52 +0100
In-Reply-To: <1449942620-29997-1-git-send-email-ola1olsson@gmail.com> (sfid-20151212_185034_980536_950AE3D4)
References: <1449942620-29997-1-git-send-email-ola1olsson@gmail.com>
	 (sfid-20151212_185034_980536_950AE3D4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-12-12 at 18:50 +0100, Ola Olsson wrote:
> The arg[c|v] variables are incremented even if
> they are not used afterwards. Fix that.

Good find, thanks, but I think I'd rather leave the code as is - the
compiler ought to discard the useless code anyway, but somebody editing
it later might have it easier if it's already done.

johannes
