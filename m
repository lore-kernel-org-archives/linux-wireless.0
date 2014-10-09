Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56989 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbaJIIgu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 04:36:50 -0400
Message-ID: <1412843805.1828.24.camel@jlt4.sipsolutions.net> (sfid-20141009_103655_424477_AA7D663F)
Subject: Re: [PATCH v2 2/2] iw: add vendor send command
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 09 Oct 2014 10:36:45 +0200
In-Reply-To: <1410778078-25244-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140915_124826_584469_C9D374FB)
References: <1410778078-25244-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140915_124826_584469_C9D374FB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-09-15 at 12:47 +0200, Janusz Dziedzic wrote:

> +	while ((data = fgetc(file)) != EOF) {

Why are you using fgetc() rather than just fread() or read()?

johannes


